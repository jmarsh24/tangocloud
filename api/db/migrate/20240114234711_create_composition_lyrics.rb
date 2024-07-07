class CreateCompositionLyrics < ActiveRecord::Migration[7.1]
  def change
    create_table :composition_lyrics, id: :uuid do |t|
      t.references :composition, null: false, foreign_key: true, type: :uuid
      t.references :lyric, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
