class AddNormalizedName < ActiveRecord::Migration[7.1]
  def change
    add_column :lyricists, :normalized_name, :string
    add_column :composers, :normalized_name, :string
    add_column :orchestras, :normalized_name, :string
    add_column :singers, :normalized_name, :string
    add_index :lyricists, :normalized_name, unique: true
    add_index :composers, :normalized_name, unique: true
    add_index :orchestras, :normalized_name, unique: true
    add_index :singers, :normalized_name, unique: true
  end
end
