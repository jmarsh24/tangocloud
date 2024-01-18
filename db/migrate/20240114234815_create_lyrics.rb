# frozen_string_literal: true

class CreateLyrics < ActiveRecord::Migration[7.1]
  def change
    create_table :lyrics, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :locale, null: false, default: ""
      t.text :content, null: false, default: ""
      t.references :composition, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
