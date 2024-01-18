# frozen_string_literal: true

class CreateRecordings < ActiveRecord::Migration[7.1]
  def change
    create_table :recordings, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :title, null: false, default: ""
      t.integer :bpm
      t.integer :type, null: false, default: "0"
      t.date :release_date
      t.date :recorded_date
      t.string :tangotube_slug
      t.references :orchestra, foreign_key: true, null: false, type: :string
      t.references :singer, foreign_key: true, null: false, type: :string
      t.references :composition, foreign_key: true, null: false, type: :string
      t.references :label, foreign_key: true, null: false, type: :string
      t.references :genre, foreign_key: true, null: false, type: :string
      t.references :period, foreign_key: true, null: false, type: :string
    end
  end
end
