class RemoveMethodFromAudioTransfer < ActiveRecord::Migration[7.1]
  def change
    remove_column :audio_transfers, :method, :string
    remove_column :audio_transfers, :recording_date, :date
  end
end
