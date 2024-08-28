class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :sort_name
      t.string :nickname
      t.string :birth_place
      t.string :normalized_name, null: false, default: ""
      t.string :pseudonym
      t.text :bio
      t.date :birth_date
      t.date :death_date
      t.belongs_to :el_recodo_person, foreign_key: {to_table: :external_catalog_el_recodo_people}, type: :uuid, null: true

      t.timestamps
    end

    add_index :people, :slug, unique: true
    add_index :people, :sort_name
    add_index :people, :name, unique: true
    add_index :people, :normalized_name, unique: true
  end
end
