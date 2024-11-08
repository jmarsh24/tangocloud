class SearchController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index

  def index
    @results = Searchkick.search(
      params[:query].to_s.strip,
      models: [Playlist, Recording, Orchestra, Tanda],
      model_includes: {
        Playlist => [:user, image_attachment: :blob],
        Recording => [
          :composition,
          :orchestra,
          :genre,
          :singers,
          digital_remasters: [
            audio_variants: [
              audio_file_attachment: :blob
            ],
            album: [
              album_art_attachment: :blob
            ]
          ]
        ],
        Orchestra => [
          :genres,
          recordings: [
            :composition,
            :genre,
            :singers,
            digital_remasters: [
              album: [
                album_art_attachment: :blob
              ]
            ]
          ]
        ],
        Tanda => [
          :user,
          recordings: [
            :composition,
            :orchestra,
            :genre,
            :singers,
            digital_remasters: [
              audio_variants: [
                audio_file_attachment: :blob
              ],
              album: [
                album_art_attachment: :blob
              ]
            ]
          ]
        ]
      },
      limit: 100
    )

    # @top_result = @results.first
    @playlists = @results.select { |result| result.is_a?(Playlist) }
    @recordings = @results.select { |result| result.is_a?(Recording) }.slice(0, 16)
    @orchestras = @results.select { |result| result.is_a?(Orchestra) }
    @tandas = @results.select { |result| result.is_a?(Tanda) }

    authorize :search, :index?
  end
end
