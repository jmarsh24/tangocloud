module Export
  class SampleMapper
    SampleMapping = Data.define(
      :filename,
      :audio_file_blob_id,
      :audio_variant_blob_id,
      :digital_remaster_duration,
      :digital_remaster_bpm,
      :digital_remaster_replay_gain,
      :digital_remaster_peak_value,
      :waveform_datum_id,
      :waveform_image_blob_id
    ).freeze

    def initialize(sample_filenames)
      @sample_filenames = sample_filenames
    end

    def generate_mapping
      sample_audio_files = AudioFile
        .includes(digital_remaster: {
          waveform: [:waveform_datum, image_attachment: :blob],
          audio_variants: [audio_file_attachment: :blob]
        }).where(filename: @sample_filenames)

      sample_audio_files.map do |audio_file|
        SampleMapping.new(
          filename: audio_file.filename,
          audio_file_blob_id: audio_file.file.blob.id,
          audio_variant_blob_id: audio_file.digital_remaster.audio_variants.first.audio_file.blob.id,
          digital_remaster_duration: audio_file.digital_remaster.duration,
          digital_remaster_bpm: audio_file.digital_remaster.bpm,
          digital_remaster_replay_gain: audio_file.digital_remaster.replay_gain,
          digital_remaster_peak_value: audio_file.digital_remaster.peak_value,
          waveform_datum_id: audio_file.digital_remaster.waveform.waveform_datum.id,
          waveform_image_blob_id: audio_file.digital_remaster.waveform.image.blob.id
        )
      end
    end
  end
end
