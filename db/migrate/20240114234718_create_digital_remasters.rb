class CreateDigitalRemasters < ActiveRecord::Migration[7.1]
  def change
    create_table :digital_remasters, id: :uuid do |t|
      t.integer :duration, null: false, default: 0
      t.integer :bpm
      t.string :external_id
      t.decimal :replay_gain, precision: 5, scale: 2
      t.decimal :peak_value, precision: 8, scale: 6
      t.integer :tango_cloud_id, null: false
      t.belongs_to :album, foreign_key: true, type: :uuid, null: false
      t.belongs_to :remaster_agent, foreign_key: true, type: :uuid
      t.belongs_to :recording, foreign_key: true, type: :uuid, null: false
      t.belongs_to :audio_file, foreign_key: {to_table: :import_audio_files}, type: :uuid, null: false

      t.timestamps
    end
    add_index :digital_remasters, :external_id, unique: true
    add_index :digital_remasters, :tango_cloud_id, unique: true
  end
end
