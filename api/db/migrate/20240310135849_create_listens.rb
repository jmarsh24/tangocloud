class CreateListens < ActiveRecord::Migration[6.0]
  def change
    create_table :listens, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :recording, null: false, foreign_key: true, type: :uuid
      t.datetime :listened_at, null: false

      t.timestamps
    end
  end
end
