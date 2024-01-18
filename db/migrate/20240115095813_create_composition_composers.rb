# frozen_string_literal: true

class CreateCompositionComposers < ActiveRecord::Migration[7.1]
  def change
    create_table :composition_composers, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.references :composition, null: false, foreign_key: true, type: :string
      t.references :composer, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
