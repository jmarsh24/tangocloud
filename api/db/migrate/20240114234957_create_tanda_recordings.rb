class CreateTandaRecordings < ActiveRecord::Migration[7.1]
  def change
    create_table :tanda_recordings do |t|
      t.integer :position, null: false, default: 0
      t.belongs_to :tanda, null: false, foreign_key: true
      t.belongs_to :recording, null: false, foreign_key: true
      t.timestamps
    end
  end
end
