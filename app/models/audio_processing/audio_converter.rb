module AudioProcessing
  class AudioConverter
    def convert(path, strip_metadata: true)
      @output_dir ||= File.dirname(path)
      movie = FFMPEG::Movie.new(path)
      Tempfile.create(["converted-audio", ".m4a"]) do |tempfile|
        custom_options = [
          "-map", "0:a:0",            # Map the first audio stream
          "-codec:a", "aac",          # Use AAC codec for wide compatibility
          "-b:a", "192k",             # Bitrate: 192 kbps (adjustable for quality)
          "-movflags", "+faststart",  # Optimize for streaming and seeking
          "-ar", "48000",             # Sample rate: 48 kHz
          "-ac", "1"                  # Stereo output (adjust as needed)
        ]

        # Strip metadata if requested
        custom_options += ["-map_metadata", "-1"] if strip_metadata

        movie.transcode(tempfile.path, custom_options) do |progress|
          puts progress
        end

        yield tempfile if block_given?
      end
    end
  end
end
