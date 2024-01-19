# frozen_string_literal: true

class CreateUserSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_settings, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.belongs_to :user, null: false, foreign_key: true, type: :string
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
