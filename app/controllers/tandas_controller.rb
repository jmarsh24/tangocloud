class TandasController < ApplicationController
  include RemoteModal

  respond_with_remote_modal only: [:edit]

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

    recommended_recordings = RecordingRecommendation.new(@tanda.recordings.order(position: :asc)).recommend_recordings

    orchestra_ids = @tanda_recordings.joins(:recording).select("DISTINCT recordings.orchestra_id").pluck(:orchestra_id)
    singer_ids = @tanda_recordings.flat_map { _1.recording.singers.pluck(:id) }.uniq
    recording_ids = @tanda_recordings.pluck(:recording_id)

    recordings_with_orchestra = Recording.where(orchestra_id: orchestra_ids)
      .where.not(id: recording_ids)
      .where("recordings.year BETWEEN ? AND ?", @tanda_recordings.first.recording.year - 5, @tanda_recordings.first.recording.year + 5)

    recordings_with_singers = Recording.joins(:singers)
      .where(singers: {id: singer_ids})
      .where.not(id: recording_ids)
      .where("recordings.year BETWEEN ? AND ?", @tanda_recordings.first.recording.year - 5, @tanda_recordings.first.recording.year + 5)

    additional_recommendations = (recordings_with_orchestra + recordings_with_singers)
      .uniq
      .sort_by(&:popularity_score)
      .reverse
      .take(10)

    @recommended_recordings = (recommended_recordings + additional_recommendations).take(5)
  end

  def new
    @tanda = Tanda.create!(title: "My New Tanda", user: current_user)
    authorize @tanda
    redirect_to tanda_path(@tanda)
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
