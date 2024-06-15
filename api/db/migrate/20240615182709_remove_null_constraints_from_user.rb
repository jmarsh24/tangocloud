class RemoveNullConstraintsFromUser < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :password_digest, true
    change_column_null :users, :username, true
  end
end
