class OrchestrasController < ApplicationController
  before_action :set_orchestra, only: :show
  skip_before_action :authenticate_user!, only: :show
  skip_after_action :verify_authorized, only: :show

  def index
    @orchestras = policy_scope(Orchestra.ordered_by_recordings).limit(100).with_attached_image
    authorize Orchestra
  end

  def show
    return render template: "orchestras/meta_tags", layout: false if crawler_request?

    authenticate_user! && return
    authorize @orchestra

    @filters = params.permit(:year, :genre, :orchestra_period, :singer, :sort, :order).to_h

    query = Recording::Query.new(
      orchestra: @orchestra.slug,
      year: @filters[:year],
      genre: @filters[:genre],
      orchestra_period: @filters[:orchestra_period],
      singer: @filters[:singer]
    )

    sort_column = case @filters[:sort]
    when "year" then "recordings.year"
    when "popularity" then "recordings.popularity_score"
    else "recordings.popularity_score"
    end
    sort_direction = (@filters[:order] == "asc") ? :asc : :desc

    @recordings = query.results
      .order("#{sort_column} #{sort_direction}")
      .limit(200)

    @years = query.years
    @genres = query.genres
    @orchestra_periods = query.orchestra_periods
    @singers = query.singers

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_orchestra
    @orchestra = Orchestra.includes(
      :genres,
      recordings: [
        :composition,
        digital_remasters: [album: [album_art_attachment: :blob]]
      ]
    ).friendly.find(params[:id])
  end

  def crawler_request?
    browser = Browser.new(request.user_agent)
    browser.bot?
  end
end
