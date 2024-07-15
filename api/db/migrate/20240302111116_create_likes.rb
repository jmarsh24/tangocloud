class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes, id: :uuid do |t|
      t.references :likeable, polymorphic: true, null: false, type: :uuid
      t.belongs_to :user, type: :uuid, foreign_key: true, null: false

      t.timestamps
    end
    add_index :likes, [:likeable_type, :likeable_id]
    add_index :likes, [:user_id, :likeable_type, :likeable_id], unique: true
  end
end
