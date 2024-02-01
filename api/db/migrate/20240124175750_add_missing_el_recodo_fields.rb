class AddMissingElRecodoFields < ActiveRecord::Migration[7.1]
  def change
    add_column :el_recodo_songs, :soloist, :string
    add_column :el_recodo_songs, :director, :string
    add_column :el_recodo_songs, :normalized_soloist, :string
    add_column :el_recodo_songs, :normalized_director, :string
  end
end
