# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :name, null: false
      t.string :description
      t.integer :type, null: false, default: "0"
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
