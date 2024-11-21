class ReprocessAudioVariantsJob < ApplicationJob
  queue_as :default

  def perform(audio_file)
    audio_file = AudioFile.find(audio_file)
    return unless audio_file.digital_remaster

    Rails.logger.info "Starting reprocessing for AudioFile ##{audio_file.id}"

    ActiveRecord::Base.transaction do
      audio_file.file.blob.open do |tempfile|
        converter = AudioProcessing::AudioConverter.new

        converter.convert(tempfile.path) do |compressed_audio|
          audio_file.digital_remaster.audio_variants.destroy_all

          # Add a new audio_variant
          audio_variant = audio_file.digital_remaster.audio_variants.create!(
            variant_file: compressed_audio,
            format: "m4a",
            bitrate: 192
          )

          Rails.logger.info "Updated audio_variant ##{audio_variant.id} for AudioFile ##{audio_file.id}"
        end
      end

      audio_file.update!(status: :completed, error_message: nil)
    rescue => e
      Rails.logger.error "Error processing AudioFile ##{audio_file.id}: #{e.message}"
      audio_file.update!(status: :failed, error_message: e.message)
      raise e
    end
  end
end
