class CreateDigitalRemasters < ActiveRecord::Migration[7.1]
  def change
    create_table :digital_remasters, id: :uuid do |t|
      t.integer :duration, null: false, default: 0
      t.integer :bpm
      t.string :external_id
      t.float :replay_gain, null: true
      t.belongs_to :album, foreign_key: true, type: :uuid, null: false
      t.belongs_to :remaster_agent, foreign_key: true, type: :uuid
      t.belongs_to :recording, foreign_key: true, type: :uuid, null: false
      t.belongs_to :audio_file, foreign_key: true, type: :uuid, null: false

      t.timestamps
    end
    add_index :digital_remasters, :external_id, unique: true
  end
end