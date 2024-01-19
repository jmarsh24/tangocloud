# frozen_string_literal: true

class CreateGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :genres do |t|
      t.string :name, null: false
      t.string :description
      t.timestamps
    end
  end
end
