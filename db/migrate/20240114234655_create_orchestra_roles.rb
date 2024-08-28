class CreateOrchestraRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestra_roles, id: :uuid do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
