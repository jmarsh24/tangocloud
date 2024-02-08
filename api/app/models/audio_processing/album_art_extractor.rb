module AudioProcessing
  class AlbumArtExtractor
    attr_reader :file, :output

    def initialize(file:, output: "/tmp")
      @file = file.to_s
      @output = output
    end

    def extract
      movie = FFMPEG::Movie.new(file)
      album_art_path = nil

      output_filename = File.basename(file, ".*") + ".jpg"
      full_output_path = File.join(output, output_filename)

      Tempfile.create(["album_art", ".jpg"], binmode: true) do |tempfile|
        options = {vcodec: "mjpeg", qscale: "1", frame_rate: "1", frames: "1", custom: ["-an"]}

        begin
          movie.transcode(tempfile.path, options)

          if File.exist?(tempfile.path) && !tempfile.size.zero?
            yield(tempfile) if block_given?

            FileUtils.mkdir_p(File.dirname(full_output_path))

            FileUtils.cp(tempfile.path, full_output_path)

            album_art_path = full_output_path
          else
            puts "No album art found in the file."
          end
        rescue FFMPEG::Error => e
          puts "Error extracting album art: #{e.message}"
        end
      end

      album_art_path
    end
  end
end
