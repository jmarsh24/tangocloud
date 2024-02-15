class ConvertAudioToAudioVariants < ActiveRecord::Migration[7.1]
  def change
    rename_table :audios, :audio_variants
  end
end
