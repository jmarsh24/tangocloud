class AddPlaylistItemsCountToPlaylists < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :playlist_items_count, :integer, default: 0
    remove_column :playlists, :songs_count, :integer
  end
end
