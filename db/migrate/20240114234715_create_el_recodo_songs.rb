# frozen_string_literal: true

class CreateElRecodoSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :el_recodo_songs do |t|
      t.date :date, null: false
      t.integer :ert_number, null: false, default: 0
      t.integer :music_id, null: false, default: 0
      t.string :title, null: false
      t.string :style
      t.string :orchestra
      t.string :singer
      t.string :composer
      t.string :author
      t.string :label
      t.text :lyrics
      t.string :normalized_title
      t.string :normalized_orchestra
      t.string :normalized_singer
      t.string :normalized_composer
      t.string :normalized_author
      t.string :search_data
      t.index :ert_number
      t.index :music_id, unique: true
      t.index :search_data, opclass: :gist_trgm_ops, using: :gist
      t.index :synced_at
      t.index :page_updated_at
      t.index :date
      t.index :normalized_title, opclass: :gist_trgm_ops, using: :gist
      t.index :normalized_orchestra, opclass: :gist_trgm_ops, using: :gist
      t.index :normalized_singer, opclass: :gist_trgm_ops, using: :gist
      t.index :normalized_composer, opclass: :gist_trgm_ops, using: :gist
      t.datetime :synced_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :page_updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.references :recording, type: :uuid
      t.timestamps
    end
  end
end
