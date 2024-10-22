class SearchController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  def index
    query = params[:query]

    @results = Searchkick.search(query, models: [Playlist, Recording, Orchestra, Tanda], limit: 100)

    @top_result = @results.first
    @playlists = @results.select { |result| result.is_a?(Playlist) }
    @recordings = @results.select { |result| result.is_a?(Recording) }.slice(0, 20)
    @orchestras = @results.select { |result| result.is_a?(Orchestra) }
    @tandas = @results.select { |result| result.is_a?(Tanda) }

    authorize :search, :index?
  end
end
