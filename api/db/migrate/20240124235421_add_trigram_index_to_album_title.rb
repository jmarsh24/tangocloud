class AddTrigramIndexToAlbumTitle < ActiveRecord::Migration[7.1]
  def change
    add_index :albums, :title, using: :gist, opclass: {title: :gist_trgm_ops}
  end
end
