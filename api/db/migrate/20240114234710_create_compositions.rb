class CreateCompositions < ActiveRecord::Migration[7.1]
  def change
    create_table :compositions do |t|
      t.string :title, null: false
      t.string :tangotube_slug
      t.belongs_to :lyricist, foreign_key: true
      t.belongs_to :composer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
