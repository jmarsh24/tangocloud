class CreateWaveforms < ActiveRecord::Migration[7.1]
  def change
    create_table :waveforms, id: :uuid do |t|
      t.references :audio_transfer, null: false, foreign_key: true, type: :uuid
      t.integer :version, null: false
      t.integer :channels, null: false
      t.integer :sample_rate, null: false
      t.integer :samples_per_pixel, null: false
      t.integer :bits, null: false
      t.integer :length, null: false
      t.float :data, array: true, default: []
      t.timestamps
    end
  end
end
