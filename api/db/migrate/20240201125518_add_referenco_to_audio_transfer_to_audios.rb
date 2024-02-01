class AddReferencoToAudioTransferToAudios < ActiveRecord::Migration[7.1]
  def change
    remove_column :audio_transfers, :audio_id, :uuid
    add_reference :audios, :audio_transfer, type: :uuid, foreign_key: true
  end
end
