# frozen_string_literal: true

class CreateCompositions < ActiveRecord::Migration[7.1]
  def change
    create_table :compositions, id: :uuid, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :title, null: false
      t.references :genre, null: false, foreign_key: true, type: :string, type: :uuid
      t.references :lyricist, null: false, foreign_key: true, type: :string, type: :uuid
      t.references :composer, null: false, foreign_key: true, type: :string, type: :uuid
      t.integer :listens_count
      t.integer :popularity

      t.timestamps
    end
  end
end
