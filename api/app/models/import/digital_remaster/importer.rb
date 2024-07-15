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
