# frozen_string_literal: true

class CreateAlbums < ActiveRecord::Migration[7.1]
  def change
    create_table :albums, id: :uuid, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :title, null: false
      t.text :description
      t.date :release_date
      t.integer :type, null: false, default: "0"
      t.integer :recordings_count, null: false, default: 0
      t.string :slug, null: false, index: true
      t.string :external_id
      t.references :transfer_agent, foreign_key: true, type: :string, type: :uuid
    end
  end
end
