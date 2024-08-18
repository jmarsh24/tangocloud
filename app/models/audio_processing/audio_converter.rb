module AudioProcessing
  class AudioConverter
    def convert(path, strip_metadata: true)
      @output_dir ||= File.dirname(path)
      movie = FFMPEG::Movie.new(path)
      Tempfile.create(["converted-audio", ".mp3"]) do |tempfile|
        custom_options = [
          "-map", "0:a:0",
          "-codec:a", "mp3",
          "-b:a", "256k",
          "-ar", "48000",
          "-ac", "1",
          "-movflags", "+faststart",
          "-id3v2_version", "3"
        ]

        custom_options += ["-map_metadata", "-1"] if strip_metadata

        movie.transcode(tempfile.path, custom_options) do |progress|
          puts progress
        end

        yield tempfile if block_given?
      end
    end
  end
end
