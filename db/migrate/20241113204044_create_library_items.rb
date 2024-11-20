class CreateLibraryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :library_items, id: :uuid do |t|
      t.references :user_library, null: false, foreign_key: true, type: :uuid
      t.references :item, polymorphic: true, null: false, type: :uuid
      t.integer :row_order
      t.timestamps
    end
  end
end
