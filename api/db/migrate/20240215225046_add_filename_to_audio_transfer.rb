class AddFilenameToAudioTransfer < ActiveRecord::Migration[7.1]
  def change
    add_column :audio_transfers, :filename, :string, null: false
    add_index :audio_transfers, :filename, unique: true
  end
end
