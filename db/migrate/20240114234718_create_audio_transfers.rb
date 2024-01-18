# frozen_string_literal: true

class CreateAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_transfers, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :method, null: false, default: ""
      t.string :external_id
      t.date :recording_date

      t.references :transfer_agent, foreign_key: true, type: :string, type: :uuid
      t.references :audio, foreign_key: true, type: :string, type: :uuid
      t.timestamps
    end
  end
end
