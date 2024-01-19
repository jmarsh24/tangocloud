# frozen_string_literal: true

class CreateAlbumAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :album_audio_transfers do |t|
      t.references :album, null: false, foreign_key: true
      t.references :audio_transfer, null: false, foreign_key: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
