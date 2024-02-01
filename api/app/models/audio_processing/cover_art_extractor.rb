module AudioProcessing
  class CoverArtExtractor
    attr_reader :file

    def initialize(file:)
      @file = file.to_s
    end

    def extract_cover_art
      movie = FFMPEG::Movie.new(file)
      cover_art_path = nil

      Tempfile.create(["cover_art", ".jpg"], binmode: true) do |tempfile|
        cover_art_path = tempfile.path
        options = {vcodec: "mjpeg", qscale: "1", frame_rate: "1", frames: "1", custom: ["-an"]}
        movie.transcode(tempfile.path, options)

        yield(tempfile) if block_given? && File.exist?(tempfile.path)
      end

      cover_art_path
    rescue FFMPEG::Error => e
      puts "Failed to extract cover art: #{e.message}"
      nil
    end
  end
end
