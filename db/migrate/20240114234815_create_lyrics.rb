# frozen_string_literal: true

class CreateLyrics < ActiveRecord::Migration[7.1]
  def change
    create_table :lyrics do |t|
      t.string :locale, null: false
      t.text :content, null: false
      t.references :composition, null: false, foreign_key: true
      t.timestamps
    end
  end
end
