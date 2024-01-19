# frozen_string_literal: true

class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :title, null: false, default: ""
      t.string :description
      t.boolean :public, null: false, default: true
      t.integer :songs_count, null: false, default: 0
      t.integer :likes_count, null: false, default: 0
      t.integer :listens_count, null: false, default: 0
      t.integer :shares_count, null: false, default: 0
      t.integer :followers_count, null: false, default: 0
      t.references :user, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
