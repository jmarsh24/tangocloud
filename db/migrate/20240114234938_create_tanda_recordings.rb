class CreateTandaRecordings < ActiveRecord::Migration[8.0]
  def change
    create_table :tanda_recordings, id: :uuid do |t|
      t.references :tanda, null: false, foreign_key: true, type: :uuid
      t.references :recording, null: false, foreign_key: true, type: :uuid
      t.integer :position, null: false

      t.timestamps
    end
  end
end
