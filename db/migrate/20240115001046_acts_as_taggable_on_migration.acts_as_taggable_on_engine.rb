# frozen_string_literal: true

# This migration comes from acts_as_taggable_on_engine (originally 1)
class ActsAsTaggableOnMigration < ActiveRecord::Migration[6.0]
  def self.up
    create_table ActsAsTaggableOn.tags_table, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.string :name
      t.timestamps
    end

    create_table ActsAsTaggableOn.taggings_table, force: true, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.belongs_to :tag, null: false, type: :string, foreign_key: {to_table: ActsAsTaggableOn.tags_table}

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.belongs_to :taggable, polymorphic: true
      t.belongs_to :tagger, polymorphic: true

      # Limit is created to prevent MySQL error on index
      # length for MyISAM table type: http://bit.ly/vgW2Ql
      t.string :context, limit: 128

      t.datetime :created_at
    end

    add_index ActsAsTaggableOn.taggings_table, [:taggable_id, :taggable_type, :context],
      name: "taggings_taggable_context_idx"
  end

  def self.down
    drop_table ActsAsTaggableOn.taggings_table
    drop_table ActsAsTaggableOn.tags_table
  end
end
