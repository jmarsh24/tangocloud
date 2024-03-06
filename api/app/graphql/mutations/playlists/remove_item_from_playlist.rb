module Mutations::Playlists
  class RemoveItemFromPlaylist < Mutations::BaseMutation
    argument :playlist_item_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(playlist_item_id:)
      playlist_audio_transfer = PlaylistAudioTransfer.find_by(id: playlist_item_id)

      if playlist_audio_transfer.nil?
        {
          success: false,
          errors: ["Playlist audio transfer not found."]
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
