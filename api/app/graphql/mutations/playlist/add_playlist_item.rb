module Mutations::Playlist
  class AddPlaylistItem < Mutations::BaseMutation
    argument :playlist_id, ID, required: true
    argument :recording_id, ID, required: true

    field :playlist, Types::PlaylistType, null: true
    field :errors, [String], null: true

    def resolve(playlist_id:, recording_id:)
      playlist = Playlist.find(playlist_id)
      recording = Recording.find(recording_id)

      playlist_item = PlaylistItem.new(playlist:, recording:)

      if playlist_item.save
        {playlist:}
      else
        {errors: playlist_item.errors.full_messages}
      end
    end
  end
end
