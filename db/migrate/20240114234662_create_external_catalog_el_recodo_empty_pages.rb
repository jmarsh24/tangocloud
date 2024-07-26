class CreateExternalCatalogElRecodoEmptyPages < ActiveRecord::Migration[7.1]
  def change
    create_table :external_catalog_el_recodo_empty_pages do |t|
      t.integer :ert_number, null: false

      t.timestamps
    end

    add_index :external_catalog_el_recodo_empty_pages, :ert_number, unique: true
  end
end
