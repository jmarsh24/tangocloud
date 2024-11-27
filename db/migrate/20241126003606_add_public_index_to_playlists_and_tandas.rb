class AddPublicIndexToPlaylistsAndTandas < ActiveRecord::Migration[8.0]
  def change
    add_index :playlists, :public
    add_index :tandas, :public
  end
end
