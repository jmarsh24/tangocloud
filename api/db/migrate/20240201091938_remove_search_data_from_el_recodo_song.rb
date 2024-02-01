class RemoveSearchDataFromElRecodoSong < ActiveRecord::Migration[7.1]
  def change
    remove_column :el_recodo_songs, :search_data, :string
  end
end
