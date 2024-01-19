# frozen_string_literal: true

class CreateUserSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_settings do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
