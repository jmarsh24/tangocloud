module Import
  module DigitalRemaster
    class Importer
      attr_reader :digital_remaster

      def initialize(builder:)
        @builder = builder
        @digital_remaster = nil
      end

      def import(audio_file:)
        audio_file.file.blob.open do |tempfile|
          ActiveRecord::Base.transaction do
            audio_file.update!(status: :processing)

            metadata = @builder.extract_metadata(file: tempfile)
            waveform = @builder.generate_waveform(file: tempfile)
            waveform_image = @builder.generate_waveform_image(file: tempfile)
            album_art = @builder.extract_album_art(file: tempfile)
            compressed_audio = @builder.compress_audio(file: tempfile)

            @digital_remaster = @builder.build_digital_remaster(
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

        @digital_remaster
      end
    end
  end
end
