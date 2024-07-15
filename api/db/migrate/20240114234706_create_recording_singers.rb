class CreateRecordingSingers < ActiveRecord::Migration[7.1]
  def change
    create_table :recording_singers, id: :uuid do |t|
      t.belongs_to :recording, null: false, foreign_key: true, type: :uuid
      t.belongs_to :person, null: false, foreign_key: true, type: :uuid
      t.boolean :soloist, null: false, default: false

      t.timestamps
    end
  end
end
