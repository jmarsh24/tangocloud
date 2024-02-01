class AddSlugToRecording < ActiveRecord::Migration[7.1]
  def change
    add_column :recordings, :slug, :string
    add_index :recordings, :slug, unique: true
  end
end
