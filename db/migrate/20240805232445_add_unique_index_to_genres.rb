class AddUniqueIndexToGenres < ActiveRecord::Migration[7.1]
  def change
    add_index :genres, :name, unique: true
  end
end
