class AddUniqueIndexOnOrchestraRolesName < ActiveRecord::Migration[7.1]
  def change
    add_index :orchestra_roles, :name, unique: true
  end
end
