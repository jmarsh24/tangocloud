class AddOrchestraNullabilityToRecordings < ActiveRecord::Migration[7.1]
  def change
    change_column_null :recordings, :orchestra_id, true
  end
end
