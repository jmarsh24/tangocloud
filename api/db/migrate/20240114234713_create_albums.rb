class CreateAlbums < ActiveRecord::Migration[7.1]
  def change
    create_enum :album_type, ["compilation", "original"]
    create_table :albums do |t|
      t.string :title, null: false
      t.text :description
      t.date :release_date
      t.integer :audio_transfers_count, null: false, default: 0
      t.string :slug, index: {unique: true}, null: false
      t.string :external_id
       t.integer :album_type, null: false, default: 0 # Changed from enum to integer
    end
  end
end
