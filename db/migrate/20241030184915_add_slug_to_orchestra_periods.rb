class AddSlugToOrchestraPeriods < ActiveRecord::Migration[8.0]
  def change
    add_column :orchestra_periods, :slug, :string
    add_index :orchestra_periods, :slug, unique: true
  end
end
