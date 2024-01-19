# frozen_string_literal: true

class CreateLyrics < ActiveRecord::Migration[7.1]
  def change
    create_table :lyrics, id: :uuid, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :locale, null: false
      t.text :content, null: false
      t.references :composition, null: false, foreign_key: true, type: :string, type: :uuid
      t.timestamps
    end
  end
end
