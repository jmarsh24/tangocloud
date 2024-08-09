class AddIndexToRemasterAgentsName < ActiveRecord::Migration[7.1]
  def change
    add_index :remaster_agents, :name, unique: true
  end
end
