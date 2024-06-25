class CreateMoodTags < ActiveRecord::Migration[7.1]
  def change
    create_table :mood_tags, id: :uuid do |t|
      t.references :mood, null: false, foreign_key: true, type: :uuid
      t.references :taggable, polymorphic: true, null: false, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :mood_tags, [:mood_id, :taggable_type, :taggable_id, :user_id]
  end
end
