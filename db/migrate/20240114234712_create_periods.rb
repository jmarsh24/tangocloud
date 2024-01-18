# frozen_string_literal: true

class CreatePeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :periods, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :name, null: false, default: ""
      t.text :description
      t.integer :start_year, null: false, default: 0
      t.integer :end_year, null: false, default: 0
      t.integer :recordings_count, null: false, default: 0
      t.string :slug, null: false, default: "", index: true
      t.timestamps
    end
  end
end
