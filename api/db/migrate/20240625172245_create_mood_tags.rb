class CreateMoodTags < ActiveRecord::Migration[6.1]
  def change
    create_table :mood_tags, id: :uuid do |t|
      t.references :recording, null: false, foreign_key: true, type: :uuid
      t.references :mood, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end

    add_index :mood_tags, [:recording_id, :mood_id, :user_id], unique: true
  end
end
