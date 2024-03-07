module Mutations::Playlists
  class ReorderPlaylistItems < Mutations::BaseMutation
    argument :playlist_id, ID, required: true
    argument :item_ids, [ID], required: true

    field :playlist, Types::PlaylistType, null: true
    field :errors, [String], null: true

    def resolve(playlist_id:, item_ids:)
      playlist = current_user.playlists.find(playlist_id)

      playlist.playlist_audio_transfers.each do |playlist_item|
        playlist_item.position = item_ids.index(playlist_item.audio_transfer_id.to_s)
        playlist_item.save
      end

      {playlist:}
    end
  end
end
