class CreateElRecodoSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :el_recodo_songs, id: :uuid do |t|
      t.date :date, null: false, index: true
      t.integer :ert_number, null: false, default: 0, index: {unique: true}
      t.string :title, null: false
      t.string :style
      t.string :label
      t.boolean :instrumental, null: false, default: true
      t.text :lyrics
      t.integer :lyrics_year
      t.string :search_data
      t.string :matrix
      t.string :disk
      t.integer :speed
      t.integer :duration
      t.datetime :synced_at, null: false, default: -> { "CURRENT_TIMESTAMP" }, index: true
      t.datetime :page_updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }, index: true
      t.belongs_to :el_recodo_orchestra, type: :uuid, index: true, foreign_key: true, null: true

      t.timestamps
    end
  end
end
