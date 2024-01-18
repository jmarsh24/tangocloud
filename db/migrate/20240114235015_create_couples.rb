# frozen_string_literal: true

class CreateCouples < ActiveRecord::Migration[7.1]
  def change
    create_table :couples, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.references :dancer, null: false, foreign_key: {to_table: :dancers}, type: :uuid
      t.references :partner, null: false, foreign_key: {to_table: :dancers}, type: :uuid
    end
    add_index :couples, [:dancer_id, :partner_id], unique: true
  end
end
