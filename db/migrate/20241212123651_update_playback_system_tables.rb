class UpdatePlaybackSystemTables < ActiveRecord::Migration[8.0]
  def change
    create_enum :shuffle_mode_type, %w[off on smart]
    create_enum :repeat_mode_type, %w[off one all]
    create_enum :queue_section_type, %w[now_playing next_up auto_queue]

    change_table :playback_sessions, bulk: true do |t|
      t.boolean :active, default: false, null: false
      t.enum :shuffle_mode, enum_type: :shuffle_mode_type, default: "off", null: false
      t.enum :repeat_mode, enum_type: :repeat_mode_type, default: "off", null: false
    end

    change_table :playback_queues, bulk: true do |t|
      t.string :source_type
      t.uuid :source_id
      t.boolean :active, default: false, null: false
      t.integer :position, default: 0, null: false
      t.boolean :system, default: false, null: false
    end

    change_table :queue_items, bulk: true do |t|
      t.enum :section, enum_type: :queue_section_type, default: "next_up"
      t.boolean :active, default: false, null: false
      t.references :tanda, type: :uuid, index: true
    end

    remove_index :queue_items, name: "index_queue_items_on_playback_queue_id_and_row_order"

    add_index :queue_items, [:playback_queue_id, :section, :row_order], unique: true

    remove_column :playback_sessions, :created_at, :datetime
    remove_column :playback_sessions, :updated_at, :datetime
    remove_column :playback_queues, :created_at, :datetime
    remove_column :playback_queues, :updated_at, :datetime
    remove_column :queue_items, :created_at, :datetime
    remove_column :queue_items, :updated_at, :datetime
    # remove_foreign_key :playback_queues, column: :current_item_id
  end
end
