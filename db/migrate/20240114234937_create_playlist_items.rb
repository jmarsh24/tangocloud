class CreatePlaylistItems < ActiveRecord::Migration[7.1]
  def change
    create_table :playlist_items, id: :uuid do |t|
      t.references :playlistable, polymorphic: true, null: false, type: :uuid
      t.belongs_to :item, polymorphic: true, null: false, type: :uuid
      t.integer :position, null: false

      t.timestamps
    end

    add_index :playlist_items, :position
  end
end
