class ReprocessAudioVariantsJob < ApplicationJob
  queue_as :default

  def perform(audio_file_id)
    audio_file = AudioFile.find(audio_file_id)
    return unless audio_file.digital_remaster

    Rails.logger.info "Starting reprocessing for AudioFile ##{audio_file.id}"

    ActiveRecord::Base.transaction do
      audio_file.file.blob.open do |tempfile|
        # Initialize the AudioConverter
        converter = AudioProcessing::AudioConverter.new

        # Convert the audio and handle the output
        converter.convert(tempfile.path) do |compressed_audio|
          # Remove existing audio_variants
          audio_file.digital_remaster.audio_variants.destroy_all

          # Add a new audio_variant
          audio_variant = audio_file.digital_remaster.audio_variants.create!(
            variant_file: compressed_audio,
            format: "mp3", # Example format
            bitrate: 256   # Example bitrate
          )

          Rails.logger.info "Updated audio_variant ##{audio_variant.id} for AudioFile ##{audio_file.id}"
        end
      end

      # Mark the audio_file as completed
      audio_file.update!(status: :completed, error_message: nil)
    rescue => e
      Rails.logger.error "Error processing AudioFile ##{audio_file.id}: #{e.message}"
      audio_file.update!(status: :failed, error_message: e.message)
      raise e # Re-raise to allow retry if configured
    end
  end
end
