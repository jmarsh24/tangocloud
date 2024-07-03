module AudioProcessing
  class AudioProcessor
    attr_reader :file, :metadata, :waveform_image, :waveform_data, :compressed_audio, :album_art

    def initialize(file:)
      @file = file
    end

    def process
      extract_waveform
      convert_audio
      extract_album_art
      extract_metadata
      self
    rescue => e
      Rails.logger.error "AudioFileProcessor failed: #{e.message}"
      raise e
    end

    private

    def extract_waveform
      @waveform_image = WaveformGenerator.new(file:).image
      @waveform_data = WaveformGenerator.new(file:).json
    end

    def convert_audio
      @compressed_audio = AudioConverter.new(file:).convert
    end

    def extract_album_art
      @album_art = AlbumArtExtractor.new(file:).extract
    end

    def extract_metadata
      @metadata = MetadataExtractor.new(file:).extract
    end
  end
end
