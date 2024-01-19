# frozen_string_literal: true

class CreateRecordings < ActiveRecord::Migration[7.1]
  def change
    create_table :recordings, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :title, null: false
      t.integer :bpm
      t.integer :type, null: false, default: "0"
      t.date :release_date
      t.date :recorded_date
      t.string :tangotube_slug
      t.belongs_to :orchestra, null: false, foreign_key: true, type: :string
      t.belongs_to :singer, null: false, foreign_key: true, type: :string
      t.belongs_to :composition, null: false, foreign_key: true, type: :string
      t.belongs_to :label, null: false, foreign_key: true, type: :string
      t.belongs_to :genre, null: false, foreign_key: true, type: :string
      t.belongs_to :period, null: false, foreign_key: true, type: :string
    end
  end
end
