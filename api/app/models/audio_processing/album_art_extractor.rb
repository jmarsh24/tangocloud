module AudioProcessing
  class AlbumArtExtractor
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def extract
      Tempfile.create(["album_art", ".jpg"]) do |tempfile|
        movie = FFMPEG::Movie.new(file.path)

        movie.transcode(tempfile.path,
          {
            vcodec: "mjpeg",
            qscale: "1",
            frame_rate: "1",
            frames: "1",
            custom: ["-an"]
          })

        if File.exist?(tempfile.path) && !tempfile.size.zero?
          yield tempfile if block_given?
        end
      end
    rescue FFMPEG::Error
      nil
    end
  end
end
