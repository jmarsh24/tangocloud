class AddAcrcloudFieldsToAudioFiles < ActiveRecord::Migration[8.0]
  def change
    add_column :audio_files, :acrcloud_status, :string
    add_column :audio_files, :acrcloud_fingerprint_id, :string
    add_column :audio_files, :acrcloud_metadata, :jsonb
  end
end
