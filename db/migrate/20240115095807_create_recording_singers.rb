# frozen_string_literal: true

class CreateRecordingSingers < ActiveRecord::Migration[7.1]
  def change
    create_table :recording_singers, id: :uuid, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.references :recording, null: false, foreign_key: true, type: :string, type: :uuid
      t.references :singer, null: false, foreign_key: true, type: :string, type: :uuid
      t.timestamps
    end
  end
end
