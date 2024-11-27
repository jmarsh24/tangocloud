class TandasController < ApplicationController
  include RemoteModal
  respond_with_remote_modal only: [:new, :edit]

  def index
    @tandas = policy_scope(Tanda.all)
      .public_tandas
      .public_in_playlists
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

  def new
    @tanda = Tanda.new
    authorize @tanda
  end

  def create
    authorize Tanda, :create?

    @tanda = Tanda.create!(user: current_user, title: tanda_params[:title])
    @user_library.library_items.create!(item: @tanda)

    redirect_to tanda_path(@tanda)
  end

  def edit
    @tanda = policy_scope(Tanda).find(params[:id])
    authorize @tanda
  end

  def update
    @tanda = policy_scope(Tanda).find(params[:id])
    authorize @tanda

    @tanda.update!(tanda_params)

    redirect_to tanda_path(@tanda)
  end

  private

  def tanda_params
    params.require(:tanda).permit(:title, :subtitle, :description, :public, :image)
  end
end
