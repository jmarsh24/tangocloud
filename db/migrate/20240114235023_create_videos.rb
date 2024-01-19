# frozen_string_literal: true

class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos, id: :uuid, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :youtube_slug, null: false
      t.string :title, null: false
      t.string :description, null: false
      t.references :recording, null: false, foreign_key: true, type: :string, type: :uuid
      t.timestamps
    end
  end
end
