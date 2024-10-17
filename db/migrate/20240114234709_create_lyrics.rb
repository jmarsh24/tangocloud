class CreateLyrics < ActiveRecord::Migration[7.1]
  def change
    create_table :lyrics do |t|
      t.text :text, null: false
      t.belongs_to :language, null: false, foreign_key: true

      t.timestamps
    end
  end
end
