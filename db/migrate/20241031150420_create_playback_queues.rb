class CreatePlaybackQueues < ActiveRecord::Migration[8.0]
  def change
    create_table :playback_queues, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.boolean :playing, default: false, null: false
      t.integer :progress, default: 0, null: false

      t.timestamps
    end
  end
end
