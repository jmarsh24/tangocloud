class CreateUserActivityLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes, id: :uuid do |t|
      t.string :likeable_type
      t.uuid :likeable_id
      t.belongs_to :user, type: :uuid, foreign_key: true
      t.timestamps
    end
    add_index :likes, [:likeable_type, :likeable_id]
  end
end
