class CreateCompositions < ActiveRecord::Migration[7.1]
  def change
    create_table :compositions, id: :uuid do |t|
      t.string :title, null: false
      t.string :tangotube_slug
      t.belongs_to :lyricist, foreign_key: true, type: :uuid
      t.belongs_to :composer, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
