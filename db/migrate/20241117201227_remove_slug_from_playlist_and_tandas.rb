class RemoveSlugFromPlaylistAndTandas < ActiveRecord::Migration[8.0]
  def change
    remove_column :playlists, :slug, :string
    remove_column :tandas, :slug, :string
  end
end
