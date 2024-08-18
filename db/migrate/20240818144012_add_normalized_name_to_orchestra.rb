class AddNormalizedNameToOrchestra < ActiveRecord::Migration[7.1]
  def change
    add_column :orchestras, :normalized_name, :string
    add_index :orchestras, :normalized_name, unique: true
  end
end
