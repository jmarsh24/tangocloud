class CreateComposers < ActiveRecord::Migration[7.1]
  def change
    create_table :composers, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name, null: true
      t.string :name, null: false
      t.date :birth_date
      t.date :death_date
      t.string :sort_name
      t.string :slug, null: false

      t.timestamps
    end

    add_index :composers, :slug, unique: true
  end
end
