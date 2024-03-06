module Mutations::Playlists
  class RemoveItemFromPlaylist < Mutations::BaseMutation
    argument :playlist_id, ID, required: true
    argument :item_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(playlist_id:, item_id:)
      playlist = Playlist.find_by(id: playlist_id)
      audio_transfer = AudioTransfer.find_by(id: item_id)
      playlist_audio_transfer = playlist.playlist_audio_transfers.find_by(audio_transfer:)

      if playlist_audio_transfer.nil?
        {
          success: false,
          errors: ["Playlist audio transfer not found."]
        }
      elsif playlist.nil?
        {
          success: false,
          errors: ["Playlist not found."]
        }
      elsif playlist_audio_transfer.destroy
        {
          success: true,
          errors: []
        }
      else
        {
          success: false,
          errors: playlist_audio_transfer.errors.full_messages
        }
      end
    end
  end
end
