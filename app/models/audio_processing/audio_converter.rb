module AudioProcessing
  class AudioConverter
    def convert(path, strip_metadata: true)
      @output_dir ||= File.dirname(path)
      movie = FFMPEG::Movie.new(path)
      Tempfile.create(["converted-audio", ".mp3"]) do |tempfile|
        custom_options = [
          "-map", "0:a:0",             # Map the first audio stream
          "-codec:a", "mp3",           # Use MP3 codec
          "-b:a", "256k",              # Bitrate: 256 kbps
          "-ar", "48000",              # Sample rate: 48 kHz
          "-ac", "1",                  # Mono output
          "-id3v2_version", "3",       # Use ID3v2.3 metadata format
          "-write_xing", "1"           # Ensure Xing header for seekability
        ]

        # Strip non-essential metadata but preserve seekability
        custom_options += ["-map_metadata", "-1"] if strip_metadata

        movie.transcode(tempfile.path, custom_options) do |progress|
          puts progress
        end

        yield tempfile if block_given?
      end
    end
  end
end
