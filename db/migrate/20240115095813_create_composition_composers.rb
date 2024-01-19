# frozen_string_literal: true

class CreateCompositionComposers < ActiveRecord::Migration[7.1]
  def change
    create_table :composition_composers do |t|
      t.references :composition, null: false, foreign_key: true
      t.references :composer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
