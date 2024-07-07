class CreateLanguages < ActiveRecord::Migration[7.1]
  def change
    create_table :languages, id: :uuid do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :languages, :code, unique: true
  end
end
