class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists do |t|
      t.string :title, null: false
      t.string :description
      t.boolean :public, null: false, default: true
      t.integer :songs_count, null: false, default: 0
      t.integer :likes_count, null: false, default: 0
      t.integer :listens_count, null: false, default: 0
      t.integer :shares_count, null: false, default: 0
      t.integer :followers_count, null: false, default: 0
      t.belongs_to :user, null: false
      t.timestamps
    end
  end
end
