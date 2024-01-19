# frozen_string_literal: true

class CreateRecordingSingers < ActiveRecord::Migration[7.1]
  def change
    create_table :recording_singers do |t|
      t.references :recording, null: false, foreign_key: true
      t.references :singer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
