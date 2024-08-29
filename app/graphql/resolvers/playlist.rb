module Resolvers
  class Playlist < BaseResolver
    type Types::PlaylistType, null: false

    argument :id, ID

    def resolve(id:)
      ::Playlist.find(id)
    end
  end
end
