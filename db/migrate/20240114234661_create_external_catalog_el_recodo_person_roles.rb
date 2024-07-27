class CreateExternalCatalogElRecodoPersonRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :external_catalog_el_recodo_person_roles, id: :uuid do |t|
      t.references :person, null: false, type: :uuid, foreign_key: {to_table: :external_catalog_el_recodo_people}
      t.references :song, null: false, type: :uuid, foreign_key: {to_table: :external_catalog_el_recodo_songs}
      t.string :role, null: false

      t.timestamps
    end
  end
end
