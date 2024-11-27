class AddDurationToTandas < ActiveRecord::Migration[8.0]
  def change
    add_column :tandas, :duration, :integer, default: 0, null: false
  end
end
