class OrchestrasController < ApplicationController
  def index
    @orchestras = policy_scope(Orchestra.ordered_by_recordings).limit(100).with_attached_image
    authorize Orchestra
  end

  def show
    @orchestra = policy_scope(
      Orchestra.includes(
        :genres,
        recordings: [
          :composition,
          digital_remasters: [album: [album_art_attachment: :blob]]
        ]
      )
    ).friendly.find(params[:id])
    authorize @orchestra

    @filters = params.permit(:year, :genre, :orchestra_period, :singer).to_h

    query = Recording::Query.new(
      orchestra: @orchestra.slug,
      year: @filters[:year],
      genre: @filters[:genre],
      orchestra_period: @filters[:orchestra_period],
      singer: @filters[:singer]
    )

    @recordings = query.results.order(popularity_score: :desc).limit(200)
    @years = query.years
    @genres = query.genres
    @orchestra_periods = query.orchestra_periods
    @singers = query.singers

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
