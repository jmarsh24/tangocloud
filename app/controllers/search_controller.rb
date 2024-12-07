class SearchController < ApplicationController
  skip_after_action :verify_authorized, only: [:index]

  def index
    authorize :search, :index?

    @query = params[:query].to_s.strip
    @filter_type = params[:filter] || "all"

    indices_boost = {
      Orchestra => 10.0,
      Recording => 2.0,
      Tanda => 1.2,
      Playlist => 1.0
    }

    search_options = {
      models: [Playlist, Recording, Orchestra, Tanda],
      model_includes: {
        Playlist => [:user, image_attachment: :blob],
        Recording => [:composition, :orchestra, :genre, :singers, digital_remasters: [:audio_variants, album: [:album_art_attachment]]],
        Orchestra => [:genres, recordings: [:composition, :genre, :singers, digital_remasters: [album: [:album_art_attachment]]]],
        Tanda => [:user, recordings: [:composition, :orchestra, :genre, :singers, digital_remasters: [:audio_variants, album: [:album_art_attachment]]]]
      },
      limit: 100,
      indices_boost: indices_boost,
      order: {_score: :desc},
      misspellings: {below: 10}
    }

    if @filter_type != "all"
      search_options[:models] = [@filter_type.classify.constantize]
    end

    @results = Searchkick.search(@query, **search_options)
    @grouped_results = @results.group_by { |result| result.class.name.downcase.pluralize.to_sym }

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "search-results",
          partial: "search_results",
          locals: {
            query: @query,
            grouped_results: @grouped_results,
            filter_type: @filter_type
          }
        )
      end
    end
  end
end
