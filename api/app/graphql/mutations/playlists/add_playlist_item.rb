module Mutations::Playlists
  class AddPlaylistItem < Mutations::BaseMutation
    argument :playlist_id, ID, required: true
    argument :item_id, ID, required: true
    argument :position, Integer, required: false

    field :playlist, Types::PlaylistType, null: true
    field :errors, [String], null: true

    def resolve(playlist_id:, item_id:, position: nil)
      playlist = Playlist.find(playlist_id)
      audio_transfer = AudioTransfer.find(item_id)
      playlist_audio_transfer = playlist.playlist_audio_transfers.build(audio_transfer:)
      playlist_audio_transfer.insert_at(position) if position.present?
      if playlist_audio_transfer.save
        {
          playlist:,
          errors: []
        }
      else
        {
          playlist: nil,
          errors: playlist_song.errors.full_messages
        }
      end
    end
  end
end
