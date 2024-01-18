# frozen_string_literal: true

class CreateAudios < ActiveRecord::Migration[7.1]
  def change
    create_table :audios, id: :uuid, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.integer :duration, null: false, default: 0
      t.string :format, null: false, default: ""
      t.integer :bit_rate
      t.integer :sample_rate
      t.integer :channels
      t.integer :bit_depth
      t.timestamps
    end
  end
end
