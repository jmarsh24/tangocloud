class DropUniqueIndexOnPeopleNames < ActiveRecord::Migration[7.1]
  def change
    remove_index :people, :name
    add_index :people, :name
  end
end
