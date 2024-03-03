module Resolvers::Playlists
  class FetchPlaylist < Resolvers::BaseResolver
    type Types::PlaylistType, null: false

    argument :id, ID, required: true, description: "ID of the playlist."

    def resolve(id:)
      Playlist.find(id)
    end
  end
end
