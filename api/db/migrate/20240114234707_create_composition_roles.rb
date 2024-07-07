class CreateCompositionRoles < ActiveRecord::Migration[7.1]
  def change
    create_enum :composition_roles, %w[composer lyricist]
    create_table :composition_roles, id: :uuid do |t|
      t.column :role, :composition_roles, null: false
      t.belongs_to :person, null: false
      t.belongs_to :composition, null: false

      t.timestamps
    end
  end
end
