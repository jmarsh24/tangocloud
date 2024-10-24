class AddIndexToRecordingsRecordedDate < ActiveRecord::Migration[8.0]
  def change
    add_index :recordings, :recorded_date
  end
end
