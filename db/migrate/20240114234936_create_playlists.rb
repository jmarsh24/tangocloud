class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists do |t|
      t.string :title, null: false
      t.string :subtitle, null: true
      t.text :description, null: true
      t.string :slug, null: true, index: {unique: true}
      t.boolean :public, null: false, default: true
      t.boolean :system, null: false, default: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
