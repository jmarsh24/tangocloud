class AddIndexToPeopleName < ActiveRecord::Migration[7.1]
  def change
    add_index :people, :name, unique: true
  end
end
