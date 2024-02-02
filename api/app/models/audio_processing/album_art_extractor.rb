module AudioProcessing
  class AlbumArtExtractor
    attr_reader :file

    def initialize(file:)
      @file = file.to_s
    end

    def extract
      movie = FFMPEG::Movie.new(file)
      album_art_path = nil

      Tempfile.create(["album_art", ".jpg"], binmode: true) do |tempfile|
        album_art_path = tempfile.path
        options = {vcodec: "mjpeg", qscale: "1", frame_rate: "1", frames: "1", custom: ["-an"]}

        begin
          movie.transcode(tempfile.path, options)

          if File.exist?(tempfile.path) && !tempfile.size.zero?
            yield(tempfile) if block_given?
          else
            puts "No album art found in the file."
            album_art_path = nil
          end
        rescue FFMPEG::Error => e
          puts "Error extracting album art: #{e.message}"
          album_art_path = nil
        end
      end

      album_art_path
    end
  end
end
