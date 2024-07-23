class CreateRecordings < ActiveRecord::Migration[7.1]
  def change
    create_enum :recording_type, ["studio", "live"]
    create_table :recordings, id: :uuid do |t|
      t.date :recorded_date
      t.string :slug, index: {unique: true}, null: false
      t.enum :recording_type, null: false, default: "studio", enum_type: :recording_type
      t.integer :playbacks_count, null: false, default: 0

      t.belongs_to :el_recodo_song, foreign_key: true, type: :uuid
      t.belongs_to :orchestra, foreign_key: true, type: :uuid, null: false
      t.belongs_to :composition, foreign_key: true, type: :uuid, null: false
      t.belongs_to :genre, foreign_key: true, type: :uuid, null: false
      t.belongs_to :record_label, foreign_key: true, type: :uuid
      t.belongs_to :time_period, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
