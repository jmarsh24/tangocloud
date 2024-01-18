# frozen_string_literal: true

class CreateLyricists < ActiveRecord::Migration[7.1]
  def change
    create_table :lyricists, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :name, null: false, default: ""
      t.string :slug, null: false, default: "", index: true
      t.string :sort_name
      t.date :birth_date
      t.date :death_date
      t.text :bio
      t.timestamps
    end
  end
end
