class CreateOrchestraPeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestra_periods, id: :uuid do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date
      t.references :orchestra, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
