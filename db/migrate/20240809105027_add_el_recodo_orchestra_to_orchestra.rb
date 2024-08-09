class AddElRecodoOrchestraToOrchestra < ActiveRecord::Migration[7.1]
  def change
    add_reference :external_catalog_el_recodo_songs, :el_recodo_orchestra, foreign_key: {to_table: :external_catalog_el_recodo_orchestras}, type: :uuid, null: true
    add_reference :orchestras, :el_recodo_orchestra, foreign_key: {to_table: :external_catalog_el_recodo_orchestras}, type: :uuid, null: true
  end
end
