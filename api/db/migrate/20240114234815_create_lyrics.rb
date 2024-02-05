class CreateLyrics < ActiveRecord::Migration[7.1]
  def change
    create_table :lyrics do |t|
      t.string :locale, null: false
      t.text :content, null: false
      t.belongs_to :composition, null: false, foreign_key: true
      t.timestamps
    end
    add_index :lyrics, [:locale, :composition_id], unique: true
  end
end
