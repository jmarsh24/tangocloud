# frozen_string_literal: true

class CreateOrchestras < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestras, id: :uuid do |t|
      t.string :name, null: false
      t.integer :rank, null: false, default: 0
      t.string :sort_name
      t.date :birth_date
      t.date :death_date
      t.string :slug, null: false, index: true
    end
  end
end
