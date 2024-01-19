# frozen_string_literal: true

class CreateCompositions < ActiveRecord::Migration[7.1]
  def change
    create_table :compositions, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :title, null: false
      t.belongs_to :genre, null: false, foreign_key: true, type: :string
      t.belongs_to :lyricist, null: false, foreign_key: true, type: :string
      t.belongs_to :composer, null: false, foreign_key: true, type: :string
      t.integer :listens_count
      t.integer :popularity

      t.timestamps
    end
  end
end
