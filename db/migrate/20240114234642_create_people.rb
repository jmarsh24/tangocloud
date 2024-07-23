class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :sort_name
      t.text :bio
      t.date :birth_date
      t.date :death_date

      t.timestamps
    end

    add_index :people, :slug, unique: true
    add_index :people, :sort_name
  end
end
