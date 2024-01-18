# frozen_string_literal: true

class CreateCompositions < ActiveRecord::Migration[7.1]
  def change
    create_table :compositions, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :title, null: false, default: ""
      t.references :genre, null: false, foreign_key: true, type: :string
      t.references :lyricist, null: false, foreign_key: true, type: :string
      t.references :composer, null: false, foreign_key: true, type: :string
      t.integer :listens_count
      t.integer :popularity

      t.timestamps
    end
  end
end
