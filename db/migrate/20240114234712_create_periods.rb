# frozen_string_literal: true

class CreatePeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :periods, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.integer :start_year, null: false, default: 0
      t.integer :end_year, null: false, default: 0
      t.integer :recordings_count, null: false, default: 0
      t.string :slug, null: false, index: true
      t.timestamps
    end
  end
end
