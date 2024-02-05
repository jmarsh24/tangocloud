class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.string :youtube_slug, null: false
      t.string :title, null: false
      t.string :description, null: false
      t.belongs_to :recording, null: false, foreign_key: true
      t.timestamps
    end
  end
end
