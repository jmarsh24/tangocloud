class CreatePlaylistAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :playlist_audio_transfers do |t|
      t.belongs_to :playlist, null: false, foreign_key: true
      t.belongs_to :audio_transfer, null: false, foreign_key: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
