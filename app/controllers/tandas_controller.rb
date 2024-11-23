class TandasController < ApplicationController
  def index
    @tandas = policy_scope(Tanda.all)
      .strict_loading
      .includes(
        :user,
        recordings: [
          :composition,
          :orchestra,
          :genre,
          :singers,
          :tags,
          digital_remasters: [
            audio_variants: [
              audio_file_attachment: :blob
            ],
            album: [
              album_art_attachment: :blob
            ]
          ]
        ]
      )

    if params[:genre].present?
      @tandas = @tandas
        .joins(recordings: :genre)
        .where(genres: {slug: params[:genre]})
        .distinct
    end

    authorize Tanda
  end

  def show
    @tanda = policy_scope(Tanda).find(params[:id])

    tanda_recordings = @tanda
      .tanda_recordings
      .includes(recording: [:composition, :orchestra, :genre, :singers, digital_remasters: [audio_variants: [audio_file_attachment: :blob], album: [album_art_attachment: :blob]]])
      .order(:position)

    @recordings = tanda_recordings.map(&:recording)

    authorize @tanda
  end
end
