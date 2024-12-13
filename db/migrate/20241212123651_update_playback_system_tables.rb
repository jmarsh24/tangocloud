class UpdatePlaybackSystemTables < ActiveRecord::Migration[8.0]
  def change
    create_enum :shuffle_mode_type, %w[off on smart]
    create_enum :repeat_mode_type, %w[off one all]
    create_enum :queue_item_source, %w[next_up auto_queue]

    change_table :playback_sessions, bulk: true do |t|
      t.boolean :active, default: false, null: false
      t.enum :shuffle_mode, enum_type: :shuffle_mode_type, default: "off", null: false
      t.enum :repeat_mode, enum_type: :repeat_mode_type, default: "off", null: false
    end

    create_table :now_playings, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.uuid :user_id, null: false
      t.string :item_type, null: false
      t.uuid :item_id, null: false
      t.integer :position, default: 0, null: false
    end

    change_table :playback_queues, bulk: true do |t|
      t.string :queue_type, null: false, default: "All"
      t.string :current_item_type
      t.boolean :active, default: false, null: false
      t.integer :position, default: 0, null: false
      t.boolean :system, default: false, null: false
    end

    change_table :queue_items, bulk: true do |t|
      t.enum :source, enum_type: :queue_item_source, default: "next_up"
    end

    remove_column :playback_sessions, :created_at, :datetime
    remove_column :playback_sessions, :updated_at, :datetime
    remove_column :playback_queues, :created_at, :datetime
    remove_column :playback_queues, :updated_at, :datetime
    remove_column :queue_items, :created_at, :datetime
    remove_column :queue_items, :updated_at, :datetime
    # remove_foreign_key :playback_queues, column: :current_item_id
  end
end
