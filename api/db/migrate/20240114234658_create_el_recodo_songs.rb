class CreateElRecodoSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :el_recodo_songs, id: :uuid do |t|
      t.date :date, null: false
      t.integer :ert_number, null: false, default: 0
      t.integer :music_id, null: false, default: 0
      t.string :title, null: false
      t.string :style
      t.string :orchestra
      t.string :singer
      t.string :soloist
      t.string :director
      t.string :composer
      t.string :author
      t.string :label
      t.jsonb :members, null: false, default: "{}"
      t.text :lyrics
      t.string :search_data
      t.index :ert_number
      t.index :music_id, unique: true
      t.index :synced_at
      t.index :page_updated_at
      t.index :date
      t.datetime :synced_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :page_updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
