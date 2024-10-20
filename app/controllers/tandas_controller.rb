class TandasController < ApplicationController
  def index
    @tandas = policy_scope(Tanda.all).with_attached_image.limit(100)

    authorize Tanda
  end

  def show
    @tanda = policy_scope(Tanda).friendly.find(params[:id])

    tanda_recordings = @tanda
      .tanda_recordings
      .includes(recording: [:composition, :orchestra, :genre, :singers, digital_remasters: [audio_variants: [audio_file_attachment: :blob], album: [album_art_attachment: :blob]]])
      .order(:position)

    @recordings = tanda_recordings.map(&:recording)

    authorize @tanda
  end
end
