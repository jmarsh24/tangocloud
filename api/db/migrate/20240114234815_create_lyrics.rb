class CreateLyrics < ActiveRecord::Migration[7.1]
  def change
    create_table :lyrics, id: :uuid do |t|
      t.string :locale, null: false
      t.text :content, null: false
      t.belongs_to :composition, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
