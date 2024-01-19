# frozen_string_literal: true

class CreateAudioTransfers < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_transfers, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :method, null: false
      t.string :external_id
      t.date :recording_date

      t.belongs_to :transfer_agent, null: false, foreign_key: true, type: :string
      t.belongs_to :audio, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
