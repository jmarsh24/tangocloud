class CreateOrchestras < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestras, id: :uuid do |t|
      t.string :name, null: false
      t.string :sort_name
      t.string :normalized_name, null: false, default: ""
      t.belongs_to :el_recodo_orchestra, foreign_key: {to_table: :external_catalog_el_recodo_orchestras}, type: :uuid, null: true

      t.string :slug, null: false
      t.timestamps
    end

    add_index :orchestras, :name, unique: true
    add_index :orchestras, :slug, unique: true
    add_index :orchestras, :sort_name
    add_index :orchestras, :normalized_name, unique: true
  end
end
