class RemoveDataFromWaveforms < ActiveRecord::Migration[7.1]
  def change
    remove_column :waveforms, :data, :float
  end
end
