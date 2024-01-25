# frozen_string_literal: true

class CreateAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_transfers, id: :uuid do |t|
      t.string :method, null: false
      t.string :external_id
      t.date :recording_date

      t.belongs_to :transfer_agent, foreign_key: true, type: :uuid
      t.belongs_to :audio, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
