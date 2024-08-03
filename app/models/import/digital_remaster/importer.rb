module Import
  module DigitalRemaster
    class Importer
      def initialize(builder:)
        @builder = builder
        @audio_file_processor = AudioFileProcessor.new
      end

      def import(audio_file:)
        audio_file.file.blob.open do |tempfile|
          ActiveRecord::Base.transaction do
            audio_file.update!(status: :processing)

            metadata = @audio_file_processor.extract_metadata(file: tempfile)
            waveform = @audio_file_processor.generate_waveform(file: tempfile)
            waveform_image = @audio_file_processor.generate_waveform_image(file: tempfile)
            album_art = @audio_file_processor.extract_album_art(file: tempfile)
            compressed_audio = @audio_file_processor.compress_audio(file: tempfile)

            @digital_remaster = @builder.build(
              audio_file:,
              metadata:,
              waveform:,
              waveform_image:,
              album_art:,
              compressed_audio:
            )

            if @digital_remaster.save!
              audio_file.update!(status: :completed, error_message: nil)
            end

            @digital_remaster
          end
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error("Digital Remaster Importer Error: #{e.message}")
          e.backtrace.each { |line| Rails.logger.error(line) }
          audio_file.update_columns(status: :failed, error_message: e.message)
        rescue => e
          Rails.logger.error("Digital Remaster Importer Error: #{e.message}")
          e.backtrace.each { |line| Rails.logger.error(line) }
          audio_file.update_columns(status: :failed, error_message: e.message)
        end
      end
    end
  end
end
