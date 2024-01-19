# frozen_string_literal: true

class CreateRecordings < ActiveRecord::Migration[7.1]
  def change
    create_table :recordings do |t|
      t.string :title, null: false
      t.integer :bpm
      t.integer :type, null: false, default: "0"
      t.date :release_date
      t.date :recorded_date
      t.string :tangotube_slug
      t.references :orchestra, foreign_key: true
      t.references :singer, foreign_key: true
      t.references :composition, foreign_key: true
      t.references :label, foreign_key: true
      t.references :genre, foreign_key: true
      t.references :period, foreign_key: true
    end
  end
end
