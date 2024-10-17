class CreateCompositionLyrics < ActiveRecord::Migration[7.1]
  def change
    create_table :composition_lyrics do |t|
      t.references :composition, null: false, foreign_key: true
      t.references :lyric, null: false, foreign_key: true

      t.timestamps
    end
  end
end
