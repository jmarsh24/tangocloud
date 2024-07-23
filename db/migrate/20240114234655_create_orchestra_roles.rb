class CreateOrchestraRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestra_roles, id: :uuid do |t|
      t.string :name, null: false
      t.belongs_to :orchestra, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
