class ReprocessAudioVariantsJob < ApplicationJob
  queue_as :background

  def perform(audio_file, format: :opus)
    return unless audio_file.digital_remaster

    Rails.logger.info "Starting reprocessing for AudioFile ##{audio_file.id} in format: #{format}"

    ActiveRecord::Base.transaction do
      audio_file.file.blob.open do |tempfile|
        converter = AudioProcessing::AudioConverter.new

        converter.convert(tempfile.path, format: format) do |compressed_audio|
          # Set format-specific attributes
          audio_format = (format == :opus) ? "opus" : "aac"
          content_type = (format == :opus) ? "audio/ogg" : "audio/mp4"
          file_extension = (format == :opus) ? ".opus" : ".m4a"
          bit_rate = (format == :opus) ? 128 : 192

          audio_variant = audio_file.digital_remaster.audio_variants.first_or_initialize(
            format: audio_format,
            bit_rate: bit_rate
          )

          audio_variant.audio_file.attach(
            io: File.open(compressed_audio),
            filename: File.basename(compressed_audio, File.extname(compressed_audio)) + file_extension,
            content_type: content_type
          )

          audio_variant.save!

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
