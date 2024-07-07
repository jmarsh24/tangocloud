class CreateCompositionRoles < ActiveRecord::Migration[7.1]
  def change
    create_enum :composition_role_type, ["composer", "lyricist"]
    create_table :composition_roles, id: :uuid do |t|
      t.column :role, :composition_role_type, null: false
      t.belongs_to :person, null: false, foreign_key: true, type: :uuid
      t.belongs_to :composition, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
