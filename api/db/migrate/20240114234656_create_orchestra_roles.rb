class CreateOrchestraRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestra_roles, id: :uuid do |t|
      t.date :start_date
      t.date :end_date
      t.boolean :principal, null: false, default: false
      t.belongs_to :orchestra, null: false, foreign_key: true, type: :uuid
      t.belongs_to :role, null: false, foreign_key: true, type: :uuid
      t.belongs_to :person, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
