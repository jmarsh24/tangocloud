# frozen_string_literal: true

class CreateAlbums < ActiveRecord::Migration[7.1]
  def change
    create_table :albums, id: :uuid do |t|
      t.string :title, null: false
      t.text :description
      t.date :release_date
      t.integer :type, null: false, default: "0"
      t.integer :recordings_count, null: false, default: 0
      t.string :slug, null: false, index: true
      t.string :external_id
      t.belongs_to :transfer_agent, foreign_key: true, type: :uuid
    end
  end
end
