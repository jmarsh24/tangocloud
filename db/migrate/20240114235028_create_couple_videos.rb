# frozen_string_literal: true

class CreateCoupleVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :couple_videos do |t|
      t.references :couple, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
    end
  end
end
