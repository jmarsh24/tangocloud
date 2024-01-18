class CreateAccountsMigration < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts
  end
end
