class CreateExternalCatalogElRecodoOrchestras < ActiveRecord::Migration[7.1]
  def change
    create_table :external_catalog_el_recodo_orchestras do |t|
      t.string :name, null: false, default: "", index: {unique: true}
      t.string :path, null: false, default: ""
      t.timestamps
    end
  end
end
