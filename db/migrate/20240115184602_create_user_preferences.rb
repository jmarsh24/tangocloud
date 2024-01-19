# frozen_string_literal: true

class CreateUserPreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :user_preferences, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :username, index: {unique: true}
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :birth_date
      t.string :locale, default: "en", null: false
      t.belongs_to :user, null: false, type: :string, foreign_key: {to_table: :action_auth_users}
      t.timestamps
    end
  end
end
