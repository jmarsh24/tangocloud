# frozen_string_literal: true

class CreateTandaAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :tanda_audio_transfers, id: :uuid do |t|
      t.integer :position, null: false, default: 0
      t.belongs_to :tanda, null: false, foreign_key: true, type: :uuid
      t.belongs_to :audio_transfer, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
