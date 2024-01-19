# frozen_string_literal: true

class CreateCouples < ActiveRecord::Migration[7.1]
  def change
    create_table :couples, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.belongs_to :dancer, null: false, type: :string, foreign_key: {to_table: :dancers}
      t.belongs_to :partner, null: false, type: :string, foreign_key: {to_table: :dancers}
    end
    add_index :couples, [:dancer_id, :partner_id], unique: true
  end
end
