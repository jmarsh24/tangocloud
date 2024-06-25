class CreateShares < ActiveRecord::Migration[6.1]
  def change
    create_table :shares, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :shareable, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end

    add_index :shares, [:user_id, :shareable_type, :shareable_id], unique: true
  end
end
