# frozen_string_literal: true

# This migration comes from action_auth (originally 20231107170349)
class CreateActionAuthSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :action_auth_sessions, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.belongs_to :action_auth_user, null: false, foreign_key: true, type: :string
      t.string :user_agent
      t.string :ip_address
      t.timestamps
    end
  end
end
