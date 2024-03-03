module Resolvers::Playlists
  class SearchPlaylists < Resolvers::BaseResolver
    type [Types::PlaylistType], null: false

    argument :query, String, required: true, description: "Search query."

    def resolve(query:)
      Playlist.search_playlists(query)
    end
  end
end
