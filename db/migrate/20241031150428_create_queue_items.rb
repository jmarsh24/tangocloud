class CreateQueueItems < ActiveRecord::Migration[8.0]
  def change
    create_table :queue_items, id: :uuid do |t|
      t.references :playback_queue, null: false, foreign_key: true, type: :uuid
      t.references :item, polymorphic: true, null: false, type: :uuid
      t.integer :position, null: false

      t.timestamps
    end

    add_index :queue_items, [:playback_queue_id, :position], unique: true
  end
end