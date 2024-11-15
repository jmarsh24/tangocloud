class AddPlaylistTypeToPlaylists < ActiveRecord::Migration[8.0]
  def change
    create_table :playlist_types, id: :uuid do |t|
      t.string :name, null: false
      t.index :name, unique: true
    end

    add_reference :playlists, :playlist_type, type: :uuid, foreign_key: true

    add_column :playlists, :import_as_tandas, :boolean, default: false, null: false

    remove_column :playlists, :system, :boolean
  end
end