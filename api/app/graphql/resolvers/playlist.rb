module Resolvers
  class Playlist < BaseResolver
    type Types::PlaylistType, null: false

    argument :id, ID

    def resolve(id:)
      check_authentication!

      ::Playlist.find(id)
    end
  end
end
