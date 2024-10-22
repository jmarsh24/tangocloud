class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :integer, null: false, default: 0
    remove_column :users, :admin, :boolean, default: false, null: false
  end
end
