# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :name, null: false, default: ""
      t.string :description
      t.integer :type, null: false, default: "0"
      t.datetime :start_date, null: false, default: ""
      t.datetime :end_date, null: false, default: ""
      t.references :action_auth_user, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
