# frozen_string_literal: true

class CreateUserSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_settings, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.belongs_to :user, null: false, type: :string, foreign_key: {to_table: :action_auth_users}
      t.boolean :admin, default: false
      t.timestamps
    end
  end
end
