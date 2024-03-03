module Mutations::Playlists
  class CreatePlaylist < Mutations::BaseMutation
    argument :title, String, required: true

    field :playlist, Types::PlaylistType, null: true
    field :errors, [String], null: true

    def resolve(title:)
      playlist = Playlist.new(title:, user: context[:current_user])

      if playlist.save
        {playlist:}
      else
        {errors: playlist.errors.full_messages}
      end
    end
  end
end
