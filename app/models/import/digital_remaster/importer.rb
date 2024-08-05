module Import
  module DigitalRemaster
    class Importer
      def initialize(metadata_extractor: nil, waveform_generator: nil, album_art_extractor: nil, audio_converter: nil)
        @metadata_extractor = metadata_extractor || AudioProcessing::MetadataExtractor.new
        @waveform_generator = waveform_generator || AudioProcessing::WaveformGenerator.new
        @album_art_extractor = album_art_extractor || AudioProcessing::AlbumArtExtractor.new
        @audio_converter = audio_converter || AudioProcessing::AudioConverter.new
      end

      def import(audio_file:)
        audio_file.file.blob.open do |tempfile|
          ActiveRecord::Base.transaction do
            audio_file.update!(status: :processing)

            metadata = @metadata_extractor.extract(file: tempfile)
            waveform = @waveform_generator.generate(file: tempfile)
            waveform_image = @waveform_generator.generate_image(file: tempfile)
            album_art = @album_art_extractor.extract(file: tempfile)
            compressed_audio = @audio_converter.convert(file: tempfile)

            builder = Builder.new(
              audio_file:,
              metadata:,
              waveform:,
              waveform_image:,
              album_art:,
              compressed_audio:
            )

            @digital_remaster = builder.build

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
