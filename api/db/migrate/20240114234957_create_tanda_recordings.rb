class CreateTandaRecordings < ActiveRecord::Migration[7.1]
  def change
    create_table :tanda_recordings, id: :uuid do |t|
      t.integer :position, null: false, default: 0
      t.belongs_to :tanda, null: false, foreign_key: true, type: :uuid
      t.belongs_to :recording, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
