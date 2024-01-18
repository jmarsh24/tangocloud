# frozen_string_literal: true

class CreateTransferAgents < ActiveRecord::Migration[7.1]
  def change
    create_table :transfer_agents, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }

      t.string :name, null: false, default: ""
      t.string :description
      t.string :url
      t.timestamps
    end
  end
end
