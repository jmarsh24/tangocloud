# frozen_string_literal: true

# This migration comes from action_auth (originally 20231107165548)
class CreateActionAuthUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :action_auth_users, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :email
      t.string :password_digest
      t.boolean :verified
      t.timestamps
    end
    add_index :action_auth_users, :email, unique: true
  end
end
