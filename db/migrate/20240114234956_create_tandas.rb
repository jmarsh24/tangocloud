# frozen_string_literal: true

class CreateTandas < ActiveRecord::Migration[7.1]
  def change
    create_table :tandas, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :name, null: false
      t.string :description
      t.boolean :public, null: false, default: true
      t.belongs_to :audio_transfer, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
