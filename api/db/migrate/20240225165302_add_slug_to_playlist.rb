class AddSlugToPlaylist < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :slug, :string
    add_index :playlists, :slug, unique: true

    reversible do |dir|
      dir.up do
        Playlist.find_each(&:save)
      end
    end
  end
end
