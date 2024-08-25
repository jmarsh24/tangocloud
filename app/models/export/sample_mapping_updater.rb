module Export
  class SampleMappingUpdater
    def initialize(sample_mappings)
      @sample_mappings = sample_mappings
    end

    def update
      AudioFile.where.not(filename: @sample_mappings.map(&:filename)).find_each do |audio_file|
        sampled_data = @sample_mappings.sample

        audio_file.file.blob.purge
        audio_file.file.update!(blob_id: sampled_data.audio_file_blob_id)
        audio_variant = audio_file.digital_remaster.audio_variants.first
        audio_variant.audio_file.blob.purge
        audio_variant.audio_file.update!(blob_id: sampled_data.audio_variant_blob_id)

        update_digital_remaster(audio_file.digital_remaster, sampled_data)
      end
    end

    private

    def update_digital_remaster(digital_remaster, sampled_data)
      digital_remaster.update!(
        duration: sampled_data.digital_remaster_duration,
        bpm: sampled_data.digital_remaster_bpm,
        replay_gain: sampled_data.digital_remaster_replay_gain,
        peak_value: sampled_data.digital_remaster_peak_value
      )

      waveform = digital_remaster.waveform
      if waveform.waveform_datum_id.present? && !@sample_mappings.map(&:waveform_datum_id).include?(waveform.waveform_datum_id)
        waveform.waveform_datum&.destroy!
        waveform.image.blob.purge
      end

      waveform.update!(waveform_datum_id: sampled_data.waveform_datum_id)
      waveform.image.update!(blob_id: sampled_data.waveform_image_blob_id)
    end
  end
end
