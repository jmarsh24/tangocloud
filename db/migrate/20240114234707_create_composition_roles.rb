class CreateCompositionRoles < ActiveRecord::Migration[7.1]
  def change
    create_enum :composition_role_type, ["composer", "lyricist"]
    create_table :composition_roles do |t|
      t.column :role, :composition_role_type, null: false
      t.belongs_to :person, null: false, foreign_key: true
      t.belongs_to :composition, null: false, foreign_key: true

      t.timestamps
    end

    add_index :composition_roles, [:role, :person_id, :composition_id], unique: true
  end
end
