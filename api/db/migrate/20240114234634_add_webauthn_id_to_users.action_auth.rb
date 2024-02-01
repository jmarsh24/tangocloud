# This migration comes from action_auth (originally 20240111142545)
class AddWebauthnIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :action_auth_users, :webauthn_id, :string
  end
end
