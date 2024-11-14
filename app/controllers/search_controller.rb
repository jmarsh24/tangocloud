class SearchController < ApplicationController
  skip_after_action :verify_policy_scoped, only: [:index, :tandas, :recordings]

  def index
    perform_global_search
  end

  def tandas
    @results = Tanda.search(params[:query], includes: tanda_includes, limit: 100)
    @top_result = @results.first
    render_search_results
  end

  def recordings
    @results = Recording.search(params[:query], includes: recording_includes, limit: 100)

    authorize :search, :index?
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.update(
            "playlist-search-results",
            partial: "playlists/search_results",
            locals: {
              results: @results
            }
          )
      end
    end
  end

  private

  def perform_global_search
    @results = Searchkick.search(
      params[:query].to_s.strip,
      models: [Playlist, Recording, Orchestra, Tanda],
      model_includes: global_includes,
      limit: 100
    )

    @top_result = @results.first
    @playlists = @results.select { |result| result.is_a?(Playlist) }
    @recordings = @results.select { |result| result.is_a?(Recording) }.slice(0, 16)
    @orchestras = @results.select { |result| result.is_a?(Orchestra) }
    @tandas = @results.select { |result| result.is_a?(Tanda) }

    authorize :search, :index?
  end

  def render_search_results
    authorize :search, :index?

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.update(
            "search-results",
            partial: "search_results",
            locals: {
              query: params[:query],
              top_result: @top_result,
              results: @results
            }
          )
      end
    end
  end

  def global_includes
    {
      Playlist => [:user, image_attachment: :blob],
      Recording => recording_includes,
      Orchestra => orchestra_includes,
      Tanda => tanda_includes
    }
  end

  def tanda_includes
    [
      :user,
      recordings: [
        :composition,
        :orchestra,
        :genre,
        :singers,
        digital_remasters: [
          audio_variants: [audio_file_attachment: :blob],
          album: [album_art_attachment: :blob]
        ]
      ]
    ]
  end

  def recording_includes
    [
      :composition,
      :orchestra,
      :genre,
      :singers,
      digital_remasters: [
        audio_variants: [audio_file_attachment: :blob],
        album: [album_art_attachment: :blob]
      ]
    ]
  end

  def orchestra_includes
    [
      :genres,
      recordings: [
        :composition,
        :genre,
        :singers,
        digital_remasters: [album: [album_art_attachment: :blob]]
      ]
    ]
  end
end