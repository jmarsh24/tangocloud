class CreateRemasterAgents < ActiveRecord::Migration[7.1]
  def change
    create_table :remaster_agents, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.string :url

      t.timestamps
    end

    add_index :remaster_agents, :name, unique: true
  end
end
