class CreatePlaybacks < ActiveRecord::Migration[6.0]
  def change
    create_table :playbacks do |t|
      t.integer :duration, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :recording, null: false, foreign_key: true

      t.timestamps
    end
  end
end
