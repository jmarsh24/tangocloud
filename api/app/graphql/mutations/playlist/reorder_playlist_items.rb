module Mutations::Playlist
  class ReorderPlaylistItems < Mutations::BaseMutation
    argument :playlist_id, ID, required: true
    argument :recording_ids, [ID], required: true

    field :playlist, Types::PlaylistType, null: true
    field :errors, [String], null: true

    def resolve(playlist_id:, recording_ids:)
      playlist = Playlist.find(playlist_id)

      playlist.playlist_items.each do |playlist_item|
        playlist_item.position = recording_ids.index(playlist_item.recording_id.to_s)
        playlist_item.save
      end

      {playlist:}
    end
  end
end
