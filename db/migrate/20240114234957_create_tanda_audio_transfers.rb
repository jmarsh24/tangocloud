# frozen_string_literal: true

class CreateTandaAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :tanda_audio_transfers do |t|
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
