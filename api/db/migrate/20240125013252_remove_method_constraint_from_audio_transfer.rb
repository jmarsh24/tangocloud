class RemoveMethodConstraintFromAudioTransfer < ActiveRecord::Migration[7.1]
  def change
    change_column_null :audio_transfers, :method, true
  end
end
