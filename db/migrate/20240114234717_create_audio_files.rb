class CreateAudioFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_files do |t|
      t.string :filename, null: false, index: {unique: true}
      t.string :format, null: false
      t.integer :status, default: 0, null: false
      t.string :error_message

      t.timestamps
    end
  end
end
