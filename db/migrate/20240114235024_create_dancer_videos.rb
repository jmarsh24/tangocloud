# frozen_string_literal: true

class CreateDancerVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :dancer_videos do |t|
      t.references :dancer, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
    end
  end
end
