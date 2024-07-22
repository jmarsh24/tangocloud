class CreateElRecodoEmptyPages < ActiveRecord::Migration[7.1]
  def change
    create_table :el_recodo_empty_pages do |t|
      t.integer :ert_number, null: false

      t.timestamps
    end

    add_index :el_recodo_empty_pages, :ert_number, unique: true
  end
end
