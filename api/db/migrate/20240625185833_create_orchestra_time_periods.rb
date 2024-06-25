class CreateOrchestraTimePeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestra_time_periods, id: :uuid do |t|
      t.references :orchestra, null: false, foreign_key: true, type: :uuid
      t.references :time_period, null: false, foreign_key: true, type: :uuid
      t.integer :start_year, null: false, default: 0
      t.integer :end_year, null: false, default: 0

      t.timestamps
    end
  end
end
