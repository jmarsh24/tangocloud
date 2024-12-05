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
    @filters = params.permit(:orchestra, :year, :singer).to_h
    @filters[:genre] = @tanda.genre.slug if @tanda.genre.present?

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

    filters = {genre: @tanda.genre.name} if @tanda.genre.present?

    search_results = Recording.search(
      "*",
      where: filters,
      aggs: [:orchestra, :singer, :year, :soloist],
      smart_aggs: false,
      limit: 0
    )

    @suggested_recordings = TandaRecommendation.new(@tanda).recommend_recordings(limit: (4 - @tanda.tanda_recordings.size))

    @orchestras = search_results.aggs["orchestra"]["buckets"]
    @singers = search_results.aggs["singer"]["buckets"]
    @soloists = search_results.aggs["soloist"]["buckets"]
    @years = search_results.aggs["year"]["buckets"].sort_by! { _1["key"] }
    @recordings = search_results.results
    @filters = {}
  end

  def new
    @tanda = Tanda.new
    authorize @tanda
    @filtered_genres = Genre.where(name: ["Tango", "Milonga", "Vals"])
  end

  def create
    title = TandaTitleGenerator.generate_new_title_for_user(current_user)
    @tanda = Tanda.new(tanda_params.merge(title:, user: current_user))
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
    params.require(:tanda).permit(:title, :subtitle, :description, :public, :image, :genre_id)
  end

  def set_tanda
    authorize @tanda = policy_scope(Tanda).find(params[:id])
  end
end
