module Resolvers::Playlists
  class SearchPlaylists < Resolvers::BaseResolver
    type Types::PlaylistType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query:)
      Playlist.search_playlists(query.presence || "*").results
    end
  end
end
