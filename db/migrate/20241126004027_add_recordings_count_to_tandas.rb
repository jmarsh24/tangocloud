class AddRecordingsCountToTandas < ActiveRecord::Migration[8.0]
  def change
    add_column :tandas, :recordings_count, :integer, default: 0, null: false
  end
end
