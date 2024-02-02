class CreateCompositionLyrics < ActiveRecord::Migration[7.1]
  def change
    create_table :composition_lyrics do |t|
      t.string :locale, null: false
      t.references :composition, null: false, foreign_key: true, type: :uuid
      t.references :lyricist, null: false, foreign_key: true, type: :uuid
      t.references :lyrics, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
