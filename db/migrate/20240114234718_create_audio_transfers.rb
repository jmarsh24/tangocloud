# frozen_string_literal: true

class CreateAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_transfers do |t|
      t.string :method, null: false
      t.string :external_id
      t.date :recording_date

      t.references :transfer_agent, foreign_key: true
      t.references :audio, foreign_key: true
      t.timestamps
    end
  end
end
