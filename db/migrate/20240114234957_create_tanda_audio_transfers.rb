# frozen_string_literal: true

class CreateTandaAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :tanda_audio_transfers, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
