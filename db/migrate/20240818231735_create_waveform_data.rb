class CreateWaveformData < ActiveRecord::Migration[7.1]
  def change
    create_table :waveform_data, id: :uuid do |t|
      t.float :data, array: true, default: [], null: false
      t.timestamps
    end

    add_reference :waveforms, :waveform_datum, type: :uuid, foreign_key: true
  end
end
