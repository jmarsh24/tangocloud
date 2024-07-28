class AddPathToOrchestra < ActiveRecord::Migration[7.1]
  def change
    add_column :external_catalog_el_recodo_orchestras, :path, :string, null: false, default: ""
  end
end
