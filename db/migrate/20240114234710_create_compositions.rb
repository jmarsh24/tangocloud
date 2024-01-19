# frozen_string_literal: true

class CreateCompositions < ActiveRecord::Migration[7.1]
  def change
    create_table :compositions do |t|
      t.string :title, null: false
      t.references :genre, null: false, foreign_key: true
      t.references :lyricist, null: false, foreign_key: true
      t.references :composer, null: false, foreign_key: true
      t.integer :listens_count
      t.integer :popularity

      t.timestamps
    end
  end
end
