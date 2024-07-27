class CreateExternalCatalogElRecodoPeople < ActiveRecord::Migration[7.1]
  def change
    create_table :external_catalog_el_recodo_people, id: :uuid do |t|
      t.string :name, null: false, default: "", index: {unique: true}
      t.date :birth_date
      t.date :death_date
      t.string :real_name
      t.string :nicknames, array: true
      t.string :place_of_birth
      t.string :path
      t.datetime :synced_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
