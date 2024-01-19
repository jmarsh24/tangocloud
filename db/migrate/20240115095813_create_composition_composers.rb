# frozen_string_literal: true

class CreateCompositionComposers < ActiveRecord::Migration[7.1]
  def change
    create_table :composition_composers, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.belongs_to :composition, null: false, foreign_key: true, type: :string
      t.belongs_to :composer, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
