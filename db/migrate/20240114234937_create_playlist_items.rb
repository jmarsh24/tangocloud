class CreatePlaylistItems < ActiveRecord::Migration[7.1]
  def change
    create_table :playlist_items do |t|
      t.references :playlistable, polymorphic: true, null: false
      t.belongs_to :item, polymorphic: true, null: false
      t.integer :position, null: false

      t.timestamps
    end

    add_index :playlist_items, :position
  end
end
