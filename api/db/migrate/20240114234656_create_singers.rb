class CreateSingers < ActiveRecord::Migration[7.1]
  def change
    create_table :singers, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :rank, null: false, default: 0
      t.boolean :soloist, null: false, default: false
      t.string :sort_name
      t.text :bio
      t.date :birth_date
      t.date :death_date

      t.timestamps
    end

    add_index :singers, :slug, unique: true
  end
end
