class CreatePlaylistItems < ActiveRecord::Migration[7.1]
  def change
    create_table :playlist_items, id: :uuid do |t|
      t.references :playlist, null: false, foreign_key: true, type: :uuid
      t.references :playable, polymorphic: true, null: false, type: :uuid
      t.integer :position, null: false

      t.timestamps
    end

    add_index :playlist_items, :position
  end
end
