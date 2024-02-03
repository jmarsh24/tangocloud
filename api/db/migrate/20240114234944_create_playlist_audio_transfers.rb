class CreatePlaylistAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :playlist_audio_transfers, id: :uuid do |t|
      t.belongs_to :playlist, null: false, foreign_key: true, type: :uuid
      t.belongs_to :audio_transfer, null: false, foreign_key: true, type: :uuid
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
