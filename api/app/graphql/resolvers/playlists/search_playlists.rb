module Resolvers::Playlists
  class SearchPlaylists < Resolvers::BaseResolver
    type Types::PlaylistType.connection_type, null: false

    argument :query, String, required: true, description: "Search query."

    def resolve(query:)
      Playlist.search_playlists(query).results
    end
  end
end
