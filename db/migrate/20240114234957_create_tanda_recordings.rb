class CreateTandaRecordings < ActiveRecord::Migration[7.1]
  def change
    create_table :tanda_recordings, id: :uuid do |t|
      t.integer :position, null: false, default: 0
      t.references :tanda, null: false, foreign_key: true, type: :uuid
      t.references :recording, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :tanda_recordings, :position
  end
end
