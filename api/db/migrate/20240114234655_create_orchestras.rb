class CreateOrchestras < ActiveRecord::Migration[7.1]
  def change
    create_table :orchestras, id: :uuid do |t|
      t.string :name, null: false
      t.string :sort_name

      t.string :slug, null: false
      t.timestamps
    end

    add_index :orchestras, :name, unique: true
    add_index :orchestras, :slug, unique: true
    add_index :orchestras, :sort_name
  end
end
