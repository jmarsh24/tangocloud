class CreateRecordings < ActiveRecord::Migration[7.1]
  def change
    create_enum :recording_type, ["studio", "live"]
    create_table :recordings, id: :uuid do |t|
      t.string :title, null: false
      t.integer :bpm
      t.date :release_date
      t.date :recorded_date
      t.string :slug, index: {unique: true}, null: false
      t.enum :recording_type, null: false, default: "studio", enum_type: :recording_type
      t.belongs_to :el_recodo_song, foreign_key: true, type: :uuid
      t.belongs_to :orchestra, foreign_key: true, type: :uuid
      t.belongs_to :singer, foreign_key: true, type: :uuid
      t.belongs_to :composition, foreign_key: true, type: :uuid
      t.belongs_to :record_label, foreign_key: true, type: :uuid
      t.belongs_to :genre, foreign_key: true, type: :uuid
      t.belongs_to :period, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
