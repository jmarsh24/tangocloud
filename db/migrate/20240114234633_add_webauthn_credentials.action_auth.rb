# frozen_string_literal: true

# This migration comes from action_auth (originally 20240111125859)
class AddWebauthnCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :action_auth_webauthn_credentials, id: :uuid do |t|
      t.string :external_id, null: false
      t.string :public_key, null: false
      t.string :nickname, null: false
      t.bigint :sign_count, null: false, default: 0

      t.index :external_id, unique: true

      t.belongs_to :action_auth_user, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
