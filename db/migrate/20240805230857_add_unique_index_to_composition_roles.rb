class AddUniqueIndexToCompositionRoles < ActiveRecord::Migration[7.1]
  def change
    add_index :composition_roles, [:role, :person_id, :composition_id], unique: true
  end
end
