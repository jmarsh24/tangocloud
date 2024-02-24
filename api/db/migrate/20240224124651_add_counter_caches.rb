class AddCounterCaches < ActiveRecord::Migration[7.1]
  def change
    add_column :orchestras, :recordings_count, :integer, default: 0
    add_column :compositions, :recordings_count, :integer, default: 0
    add_column :genres, :recordings_count, :integer, default: 0
  end
end
