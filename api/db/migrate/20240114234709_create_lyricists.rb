class CreateLyricists < ActiveRecord::Migration[7.1]
  def change
    create_table :lyricists, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :sort_name
      t.date :birth_date
      t.date :death_date
      t.text :bio

      t.timestamps
    end

    add_index :lyricists, :slug, unique: true
  end
end
