class AddPlaylistTypeToPlaylists < ActiveRecord::Migration[8.0]
  def up
    create_enum :playlist_type, %w[system like editor user milonga]
    add_column :playlists, :playlist_type, :playlist_type, default: "user", null: false
    remove_column :playlists, :system
  end
end
