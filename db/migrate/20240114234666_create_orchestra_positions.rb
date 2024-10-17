class CreateOrchestraPositions < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestra_positions do |t|
      t.date :start_date
      t.date :end_date
      t.boolean :principal, null: false, default: false
      t.belongs_to :orchestra, null: false, foreign_key: true
      t.belongs_to :orchestra_role, null: false, foreign_key: true
      t.belongs_to :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
