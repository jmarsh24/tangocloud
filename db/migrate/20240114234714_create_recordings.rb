# frozen_string_literal: true

class CreateRecordings < ActiveRecord::Migration[7.1]
  def change
    create_table :recordings, id: :uuid, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :title, null: false, default: ""
      t.integer :bpm
      t.integer :type, null: false, default: "0"
      t.date :release_date
      t.date :recorded_date
      t.string :tangotube_slug
      t.references :orchestra, foreign_key: true, type: :string, type: :uuid
      t.references :singer, foreign_key: true, type: :string, type: :uuid
      t.references :composition, foreign_key: true, type: :string, type: :uuid
      t.references :label, foreign_key: true, type: :string, type: :uuid
      t.references :genre, foreign_key: true, type: :string, type: :uuid
      t.references :period, foreign_key: true, type: :string, type: :uuid
    end
  end
end
