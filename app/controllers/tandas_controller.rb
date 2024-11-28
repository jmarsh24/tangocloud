class TandasController < ApplicationController
  include RemoteModal

  respond_with_remote_modal only: [:new, :edit]

  before_action :set_tanda, only: [:show, :edit, :update]

  def index
    @tandas = policy_scope(Tanda)
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
    @tanda_recordings = @tanda
      .tanda_recordings
      .includes(
        recording: [
          :composition,
          :orchestra,
          :genre,
          :singers,
          digital_remasters: [
            audio_variants: [audio_file_attachment: :blob],
            album: [album_art_attachment: :blob]
          ]
        ]
      )
      .rank(:position)

    @recommended_recordings = RecordingRecommendation.new(@tanda.recordings.order(position: :asc)).recommend_recordings
  end

  def new
    @tanda = Tanda.new
    authorize @tanda
  end

  def create
    @tanda = Tanda.new(tanda_params.merge(user: current_user))
    authorize @tanda
    @tanda.save!
    @user_library.library_items.create!(item: @tanda)
    redirect_to tanda_path(@tanda)
  end

  def edit
  end

  def update
    @tanda.update!(tanda_params)
    redirect_to tanda_path(@tanda)
  end

  private

  def tanda_params
    params.require(:tanda).permit(:title, :subtitle, :description, :public, :image)
  end

  def set_tanda
    authorize @tanda = policy_scope(Tanda).find(params[:id])
  end
end
