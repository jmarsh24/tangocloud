# frozen_string_literal: true

class CreateAlbums < ActiveRecord::Migration[7.1]
  def change
    create_table :albums, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :title, null: false
      t.text :description
      t.date :release_date
      t.integer :type, null: false, default: "0"
      t.integer :recordings_count, null: false, default: 0
      t.string :slug, null: false, index: true
      t.string :external_id
      t.belongs_to :transfer_agent, null: false, foreign_key: true, type: :string
    end
  end
end
