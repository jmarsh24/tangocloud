module Import
  module AudioTransfer
    class Director
      attr_reader :audio_transfer

      def initialize(builder:)
        @builder = builder
        @audio_transfer = nil
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

            @audio_transfer = @builder.build_audio_transfer(
              audio_file:,
              metadata:,
              waveform:,
              waveform_image:,
              album_art:,
              compressed_audio:
            )

            if @audio_transfer.save
              audio_file.update!(status: :completed)
            else
              binding.irb
              audio_file.update!(status: :failed, error_message: @audio_transfer.errors.full_messages.join(", "))
              raise ActiveRecord::Rollback
            end
          end
        end

        @audio_transfer
      rescue => e
        audio_file.update!(status: :failed, error_message: e.message)
        raise e
      end
    end
  end
end
