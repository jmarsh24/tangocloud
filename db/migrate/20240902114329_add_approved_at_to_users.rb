class AddApprovedAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :approved_at, :datetime
  end
end
