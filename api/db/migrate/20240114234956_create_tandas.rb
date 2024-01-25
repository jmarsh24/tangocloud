# frozen_string_literal: true

class CreateTandas < ActiveRecord::Migration[7.1]
  def change
    create_table :tandas, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :public, null: false, default: true
      t.belongs_to :audio_transfer, null: false, foreign_key: true, type: :uuid
      t.belongs_to :user, null: false, foreign_key: {to_table: :action_auth_users}, type: :uuid
      t.timestamps
    end
  end
end
