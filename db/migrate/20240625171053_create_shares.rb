class CreateShares < ActiveRecord::Migration[6.1]
  def change
    create_table :shares do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shareable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :shares, [:user_id, :shareable_type, :shareable_id], unique: true
  end
end
