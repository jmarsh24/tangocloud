class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists, id: :uuid do |t|
      t.string :title, null: false
      t.string :description
      t.string :slug, null: true, index: {unique: true}
      t.boolean :public, null: false, default: true
      t.boolean :system, null: false, default: false
      t.belongs_to :user, null: false, type: :uuid

      t.timestamps
    end
  end
end
