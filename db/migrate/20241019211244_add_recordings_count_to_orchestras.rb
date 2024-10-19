class AddRecordingsCountToOrchestras < ActiveRecord::Migration[8.0]
  def change
    add_column :orchestras, :recordings_count, :integer
  end
end
