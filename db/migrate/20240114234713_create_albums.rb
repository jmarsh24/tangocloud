class CreateAlbums < ActiveRecord::Migration[7.1]
  def change
    create_table :albums do |t|
      t.string :title, null: false
      t.text :description
      t.date :release_date
      t.string :external_id

      t.timestamps
    end

    add_index :albums, :title, unique: true
  end
end
