module AudioProcessing
  class AlbumArtExtractor
    def initialize(file:)
      @file = file
    end

    def extract
      Tempfile.create(["album-art_", ".jpg"]) do |tempfile|
        movie = FFMPEG::Movie.new(@file.path)

        if !movie.valid?
          raise FFMPEG::Error, "Invalid audio file"
        end

        movie.transcode(tempfile.path,
          vcodec: "mjpeg",
          qscale: "1",
          frame_rate: "1",
          frames: "1",
          custom: ["-an"])

        yield tempfile if block_given?

        tempfile
      end
    rescue FFMPEG::Error => e
      Rails.logger.error "Failed to extract album art: #{e.message}"
      nil
    end
  end
end
