class AddFilenamesToAudios < ActiveRecord::Migration[7.1]
  def change
    add_column :audios, :filename, :string
    add_index :audios, :filename, unique: true
  end
end
