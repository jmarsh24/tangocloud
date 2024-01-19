# frozen_string_literal: true

class CreateOrchestras < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestras, id: :uuid, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :name, null: false
      t.integer :rank, null: false, default: 0
      t.string :sort_name
      t.date :birth_date
      t.date :death_date
      t.string :slug, null: false, index: true
    end
  end
end
