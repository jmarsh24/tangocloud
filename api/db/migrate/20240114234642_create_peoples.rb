class CreatePeoples < ActiveRecord::Migration[7.1]
  def change
    create_table :peoples, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :sort_name
      t.text :bio
      t.date :birth_date
      t.date :death_date

      t.timestamps
    end

    add_index :peoples, :slug, unique: true
    add_index :peoples, :sort_name
  end
end
