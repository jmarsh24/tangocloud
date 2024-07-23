class CreateLyrics < ActiveRecord::Migration[7.1]
  def change
    create_table :lyrics, id: :uuid do |t|
      t.text :text, null: false
      t.belongs_to :composition, null: false, foreign_key: true, type: :uuid
      t.belongs_to :language, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :lyrics, [:composition_id, :language_id], unique: true
  end
end
