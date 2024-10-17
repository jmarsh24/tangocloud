class CreateWaveformData < ActiveRecord::Migration[7.1]
  def change
    create_table :waveform_data do |t|
      t.text :data, :text, default: "", null: false
      t.timestamps
    end
  end
end
