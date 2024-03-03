module Mutations::Playlist
  class UpdatePlaylist < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: true
    argument :description, String, required: true

    field :playlist, Types::PlaylistType, null: true
    field :errors, [String], null: true

    def resolve(id:, title:, description:)
      playlist = Playlist.find(id)

      if playlist.update(title:, description:)
        {playlist:}
      else
        {errors: playlist.errors.full_messages}
      end
    end
  end
end
