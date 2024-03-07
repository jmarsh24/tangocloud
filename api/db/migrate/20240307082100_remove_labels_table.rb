class RemoveLabelsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :labels
  end
end
