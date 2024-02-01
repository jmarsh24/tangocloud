class RemoveGenreFromComposition < ActiveRecord::Migration[7.1]
  def change
    remove_column :compositions, :genre_id, :uuid
  end
end
