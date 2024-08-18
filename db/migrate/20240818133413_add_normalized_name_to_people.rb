class AddNormalizedNameToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :normalized_name, :string
    add_index :people, :normalized_name, unique: true
  end
end
