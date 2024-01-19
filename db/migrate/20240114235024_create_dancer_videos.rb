# frozen_string_literal: true

class CreateDancerVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :dancer_videos, id: :uuid do |t|
      t.belongs_to :dancer, null: false, foreign_key: true, type: :uuid
      t.belongs_to :video, null: false, foreign_key: true, type: :uuid
    end
  end
end
