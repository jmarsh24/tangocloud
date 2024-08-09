class AddIndexToAlbumsTitle < ActiveRecord::Migration[7.1]
  def change
    add_index :albums, :title, unique: true
  end
end
