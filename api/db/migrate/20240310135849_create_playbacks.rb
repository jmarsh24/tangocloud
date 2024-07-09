class CreatePlaybacks < ActiveRecord::Migration[6.0]
  def change
    create_table :playbacks, id: :uuid do |t|
      t.integer :duration, null: false, default: 0
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :recording, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
