class CreateWaveforms < ActiveRecord::Migration[7.1]
  def change
    create_table :waveforms do |t|
      t.integer :version, null: false
      t.integer :channels, null: false
      t.integer :sample_rate, null: false
      t.integer :samples_per_pixel, null: false
      t.integer :bits, null: false
      t.integer :length, null: false
      t.belongs_to :digital_remaster, null: false, foreign_key: true
      t.belongs_to :waveform_datum, null: false, foreign_key: true

      t.timestamps
    end
  end
end
