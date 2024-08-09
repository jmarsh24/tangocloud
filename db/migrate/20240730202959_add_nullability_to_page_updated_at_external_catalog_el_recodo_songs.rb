class AddNullabilityToPageUpdatedAtExternalCatalogElRecodoSongs < ActiveRecord::Migration[7.1]
  def change
    change_column_null :external_catalog_el_recodo_songs, :page_updated_at, true
  end
end
