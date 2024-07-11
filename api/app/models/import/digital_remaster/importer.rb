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

            metadata = AudioProcessing::MetadataExtractor.new(file: tempfile).extract
            waveform = AudioProcessing::WaveformGenerator.new(file: tempfile).generate
            waveform_image = AudioProcessing::WaveformGenerator.new(file: tempfile).generate_image
            album_art = AudioProcessing::AlbumArtExtractor.new(file: tempfile).extract
            compressed_audio = AudioProcessing::AudioConverter.new(file: tempfile).convert

            @digital_remaster = @builder.build_digital_remaster(
              audio_file:,
              metadata:,
              waveform:,
              waveform_image:,
              album_art:,
              compressed_audio:
            )

            if @digital_remaster.save
              audio_file.update!(status: :completed)
            else
              audio_file.update!(status: :failed, error_message: @digital_remaster.errors.full_messages.join(", "))
              raise ActiveRecord::Rollback
            end
          end
        rescue => e
          audio_file.update!(status: :failed, error_message: e.message)
          raise e
        end

        @digital_remaster
      end
    end
  end
end
