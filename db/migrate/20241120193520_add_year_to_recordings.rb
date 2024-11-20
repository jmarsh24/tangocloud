class AddYearToRecordings < ActiveRecord::Migration[8.0]
  def change
    add_column :recordings, :year, :integer
    add_index :recordings, :year
  end
end
