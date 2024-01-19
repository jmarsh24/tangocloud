# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :name, null: false
      t.string :description
      t.integer :type, null: false, default: "0"
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.belongs_to :user, null: false, foreign_key: {to_table: :action_auth_users}, type: :string
      t.timestamps
    end
  end
end
