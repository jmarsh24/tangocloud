class CreateLyricists < ActiveRecord::Migration[7.1]
  def change
    create_table :lyricists do |t|
      t.string :name, null: false
      t.string :slug, index: {unique: true}, null: false
      t.string :sort_name
      t.date :birth_date
      t.date :death_date
      t.text :bio
      t.timestamps
    end
  end
end
