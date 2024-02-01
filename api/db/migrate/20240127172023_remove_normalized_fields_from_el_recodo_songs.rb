class RemoveNormalizedFieldsFromElRecodoSongs < ActiveRecord::Migration[7.1]
  def change
    remove_column :el_recodo_songs, :normalized_title, :string
    remove_column :el_recodo_songs, :normalized_orchestra, :string
    remove_column :el_recodo_songs, :normalized_singer, :string
    remove_column :el_recodo_songs, :normalized_composer, :string
    remove_column :el_recodo_songs, :normalized_author, :string
    remove_column :el_recodo_songs, :normalized_soloist, :string
    remove_column :el_recodo_songs, :normalized_director, :string
  end
end
