# frozen_string_literal: true

class CreatePlaylistAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :playlist_audio_transfers, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.belongs_to :playlist, null: false, foreign_key: true, type: :string
      t.belongs_to :audio_transfer, null: false, foreign_key: true, type: :string
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
