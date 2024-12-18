class UpdatePlaybackSystemTables < ActiveRecord::Migration[8.0]
  def up
    create_enum :shuffle_mode_type, %w[off on smart]
    create_enum :repeat_mode_type, %w[off one all]
    create_enum :queue_section_type, %w[now_playing next_up auto_queue played]

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

    add_index :queue_items, [:playback_queue_id, :section, :row_order], unique: true
    remove_foreign_key :playback_queues, column: :current_item_id
  end

  def down
    add_foreign_key :playback_queues, :queue_items, column: :current_item_id
    remove_index :queue_items, [:playback_queue_id, :section, :row_order]

    change_table :queue_items, bulk: true do |t|
      t.remove :section, type: :enum
      t.remove :active, type: :boolean
      t.remove_references :tanda, type: :uuid
    end

    change_table :playback_queues, bulk: true do |t|
      t.remove :source_type, :source_id, :active, :position, :system
    end

    change_table :playback_sessions, bulk: true do |t|
      t.remove :active, :shuffle_mode, :repeat_mode
    end

    execute "DROP TYPE shuffle_mode_type;"
    execute "DROP TYPE repeat_mode_type;"
    execute "DROP TYPE queue_section_type;"

    # drop these after running
    add_timestamps :queue_items, default: -> { "CURRENT_TIMESTAMP" }, null: false
    add_timestamps :playback_sessions, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end
end
