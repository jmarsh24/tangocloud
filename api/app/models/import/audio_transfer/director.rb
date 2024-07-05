module Import
  module AudioTransfer
    class Director
      def initialize(builder:)
        @builder = builder
      end

      def import(audio_file:)
        audio_file.file.blob.open do |tempfile|
          audio_file.update!(status: :processing)
          build_audio_transfer(audio_file:, tempfile:)
        end
      rescue => e
        audio_file.update!(status: :failed, error_message: e.message)
        raise e
      end

      private

      def build_audio_transfer(audio_file:, tempfile:)
        metadata = @builder.extract_metadata(file: tempfile)
        waveform = @builder.generate_waveform(file: tempfile)
        waveform_image = @builder.generate_waveform_image(file: tempfile)
        album_art = @builder.extract_album_art(file: tempfile)
        compressed_audio = @builder.compress_audio(file: tempfile)

        audio_transfer = @builder.build_and_attach_audio_transfer(
          audio_file:,
          metadata:,
          waveform:,
          waveform_image:,
          album_art:,
          compressed_audio:
        )

        if audio_transfer.save
          audio_file.update!(status: :completed)
          audio_transfer
        else
          audio_file.update!(status: :failed, error_message: audio_transfer.errors.full_messages.join(", "))
        end
      end
    end
  end
end
