class CreateImportAudioFiles < ActiveRecord::Migration[7.1]
  def change
    create_enum :audio_file_status, ["pending", "processing", "completed", "failed"]
    create_table :import_audio_files, id: :uuid do |t|
      t.string :filename, null: false, index: {unique: true}
      t.string :format, null: false
      t.string :status, null: false, default: "pending", enum_type: :audio_file_status
      t.string :error_message

      t.timestamps
    end
  end
end
