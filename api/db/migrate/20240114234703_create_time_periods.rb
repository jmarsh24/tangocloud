class CreateTimePeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :time_periods, id: :uuid do |t|
      t.string :name, null: false, index: {unique: true}
      t.text :description
      t.integer :start_year, null: false, default: 0
      t.integer :end_year, null: false, default: 0
      t.string :slug, index: {unique: true}, null: false

      t.timestamps
    end
  end
end
