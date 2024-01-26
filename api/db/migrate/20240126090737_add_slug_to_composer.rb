# frozen_string_literal: true

class AddSlugToComposer < ActiveRecord::Migration[7.1]
  def change
    add_column :composers, :slug, :string, null: false

    add_index :composers, :slug, unique: true
  end
end
