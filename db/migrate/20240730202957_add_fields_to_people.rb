class AddFieldsToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :nickname, :string
    add_column :people, :birth_place, :string
    add_reference :people, :el_recodo_person, foreign_key: {to_table: :external_catalog_el_recodo_people}, type: :uuid, null: true
  end
end
