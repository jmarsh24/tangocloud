class AddSystemToPlaylist < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :system, :boolean, default: false, null: false
  end
end
