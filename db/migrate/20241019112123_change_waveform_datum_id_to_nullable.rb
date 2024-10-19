class ChangeWaveformDatumIdToNullable < ActiveRecord::Migration[7.2]
  def change
    # this allows recordings/digital_remasters to be destroyed
    change_column_null :waveforms, :waveform_datum_id, true
  end
end
