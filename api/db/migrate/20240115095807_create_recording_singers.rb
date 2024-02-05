class CreateRecordingSingers < ActiveRecord::Migration[7.1]
  def change
    create_table :recording_singers do |t|
      t.belongs_to :recording, null: false, foreign_key: true
      t.belongs_to :singer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
