# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :email, null: false, index: {unique: true}
      t.string :password_digest, null: false

      t.boolean :verified, null: false, default: false

      t.references :account, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
