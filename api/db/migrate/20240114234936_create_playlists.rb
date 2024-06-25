class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists, id: :uuid do |t|
      t.string :title, null: false
      t.string :description
      t.string :slug, null: true, index: {unique: true}
      t.boolean :public, null: false, default: true
      t.integer :songs_count, null: false, default: 0
      t.integer :likes_count, null: false, default: 0
      t.integer :playbacks_count, null: false, default: 0
      t.integer :shares_count, null: false, default: 0
      t.integer :followers_count, null: false, default: 0
      t.integer :playlist_items_count, null: false, default: 0
      t.boolean :system, null: false, default: false
      t.belongs_to :user, null: false, type: :uuid

      t.timestamps
    end
  end
end
