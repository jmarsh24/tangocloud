# frozen_string_literal: true

class CreateCoupleVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :couple_videos, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.belongs_to :couple, null: false, foreign_key: true, type: :string
      t.belongs_to :video, null: false, foreign_key: true, type: :string
    end
  end
end
