class AddSlugBack < ActiveRecord::Migration[8.0]
  def change
    add_column :recordings, :slug, :string
    add_column :playlists, :slug, :string
    add_column :tandas, :slug, :string
  end
end
