# frozen_string_literal: true

class CreateTandaAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :tanda_audio_transfers, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.integer :position, null: false, default: 0
      t.references :tanda, null: false, foreign_key: true, type: :string, type: :uuid
      t.references :audio_transfer, null: false, foreign_key: true, type: :string, type: :uuid
      t.timestamps
    end
  end
end
