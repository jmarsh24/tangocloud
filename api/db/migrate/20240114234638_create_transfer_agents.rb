class CreateTransferAgents < ActiveRecord::Migration[7.1]
  def change
    create_table :transfer_agents, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.string :url

      t.timestamps
    end
  end
end
