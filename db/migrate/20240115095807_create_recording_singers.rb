# frozen_string_literal: true

class CreateRecordingSingers < ActiveRecord::Migration[7.1]
  def change
    create_table :recording_singers, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.belongs_to :recording, null: false, foreign_key: true, type: :string
      t.belongs_to :singer, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
