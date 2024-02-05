class CreateCoupleVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :couple_videos do |t|
      t.belongs_to :couple, null: false, foreign_key: true
      t.belongs_to :video, null: false, foreign_key: true
    end
  end
end
