class CreateRecordings < ActiveRecord::Migration[7.1]
  def change
    create_table :recordings do |t|
      t.date :recorded_date
      t.string :slug, index: {unique: true}, null: false
      t.integer :recording_type, default: 0, null: false
      t.integer :playbacks_count, null: false, default: 0

      t.belongs_to :el_recodo_song, foreign_key: {to_table: :external_catalog_el_recodo_songs}
      t.belongs_to :orchestra, foreign_key: true, null: true
      t.belongs_to :composition, foreign_key: true, null: false
      t.belongs_to :genre, foreign_key: true, null: false
      t.belongs_to :record_label, foreign_key: true
      t.belongs_to :time_period, foreign_key: true

      t.timestamps
    end
  end
end
