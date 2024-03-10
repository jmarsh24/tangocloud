class RenameListenToPlayback < ActiveRecord::Migration[7.1]
  def change
    drop_table :listens
    create_table :playbacks, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :recording, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
