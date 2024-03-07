class RemovePlaylistAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    drop_table :playlist_audio_transfers
  end
end
