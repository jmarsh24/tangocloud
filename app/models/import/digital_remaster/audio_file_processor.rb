module Import
  module DigitalRemaster
    class AudioFileProcessor
      def extract_metadata(file)
        AudioProcessing::MetadataExtractor.new(file:).extract
      end

      def generate_waveform_image(file)
        AudioProcessing::WaveformGenerator.new(file:).generate_image
      end

      def generate_waveform(file)
        AudioProcessing::WaveformGenerator.new(file:).generate
      end

      def extract_album_art(file)
        AudioProcessing::AlbumArtExtractor.new(file:).extract
      end

      def compress_audio(file)
        AudioProcessing::AudioConverter.new(file:).convert
      end
    end
  end
end
