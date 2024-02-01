class RenameTypeColumnInAlbums < ActiveRecord::Migration[7.1]
  def change
    rename_column :albums, :type, :album_type
  end
end
