# frozen_string_literal: true

class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :youtube_slug, null: false
      t.string :title, null: false
      t.string :description, null: false
      t.belongs_to :recording, null: false, foreign_key: true, type: :string
      t.timestamps
    end
  end
end
