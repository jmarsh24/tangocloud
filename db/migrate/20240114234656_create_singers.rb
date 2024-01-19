# frozen_string_literal: true

class CreateSingers < ActiveRecord::Migration[7.1]
  def change
    create_table :singers, id: :uuid, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :name, null: false
      t.string :slug, null: false, index: true
      t.integer :rank, null: false, default: 0
      t.string :sort_name
      t.text :bio
      t.date :birth_date
      t.date :death_date
      t.timestamps
    end
  end
end
