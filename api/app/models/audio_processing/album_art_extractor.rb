module AudioProcessing
  class AlbumArtExtractor
    def initialize(file:)
      @file = file
    end

    def extract
      tempfile = Tempfile.new(["album-art_", ".jpg"], Rails.root.join("tmp"))
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

      tempfile.rewind
      tempfile
    rescue FFMPEG::Error => e
      Rails.logger.error "Failed to extract album art: #{e.message}"
      tempfile.close
      tempfile.unlink
      nil
    end
  end
end
