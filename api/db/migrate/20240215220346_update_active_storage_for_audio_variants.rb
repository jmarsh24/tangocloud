class UpdateActiveStorageForAudioVariants < ActiveRecord::Migration[7.1]
  def up
    ActiveStorage::Attachment.where(record_type: "udio").update_all(record_type: "AudioVariant")
  end

  def down
    ActiveStorage::Attachment.where(record_type: "AudioVariant").update_all(record_type: "audio")
  end
end
