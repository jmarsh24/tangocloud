class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings, id: :uuid do |t|
      t.references :tag, null: false, foreign_key: true, type: :uuid
      t.references :taggable, polymorphic: true, null: false, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :taggings, [:taggable_type, :taggable_id], name: "index_taggings_on_taggable"
    add_index :taggings, [:tag_id, :taggable_type, :taggable_id], unique: true, name: "index_taggings_on_tag_and_taggable"
  end
end
