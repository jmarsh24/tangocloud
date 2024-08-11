class RemoveOrchestraReferenceFromOrchestrRoles < ActiveRecord::Migration[7.1]
  def change
    remove_reference :orchestra_roles, :orchestra, null: false, foreign_key: true
  end
end
