module AudioProcessing
  class AudioConverter
    def convert(path, format: :aac, strip_metadata: true)
      @output_dir ||= File.dirname(path)
      case format
      when :aac
        encode_to_aac(path, strip_metadata: strip_metadata)
      when :opus
        encode_to_opus(path, strip_metadata: strip_metadata)
      else
        raise ArgumentError, "Unsupported format: #{format}. Supported formats are :aac and :opus."
      end
    end

    private

    def encode_to_aac(path, strip_metadata: true)
      Tempfile.create(["converted-audio", ".m4a"]) do |tempfile|
        custom_options = [
          "-map", "0:a:0",            # Map the first audio stream
          "-c:a", "aac",              # Use AAC codec for wide compatibility
          "-b:a", "192k",             # Bitrate: 192 kbps
          "-movflags", "+faststart",  # Optimize for streaming and seeking
          "-ar", "44100",             # Sample rate: 44.1 kHz for better compatibility
          "-ac", "1"                  # Stereo output
        ]
        # Strip metadata if requested
        custom_options += ["-map_metadata", "-1"] if strip_metadata

        process_transcoding(path, tempfile, custom_options)
      end
    end

    def encode_to_opus(path, strip_metadata: true)
      Tempfile.create(["converted-audio", ".opus"]) do |tempfile|
        custom_options = [
          "-map", "0:a:0",            # Map the first audio stream
          "-c:a", "libopus",          # Use Opus codec for modern compatibility
          "-b:a", "128k",             # Target bitrate for high-quality Opus
          "-vbr", "on",               # Enable variable bitrate
          "-ar", "48000",             # Use 48 kHz sample rate for Opus
          "-ac", "1"                  # Stereo output
        ]
        # Strip metadata if requested
        custom_options += ["-map_metadata", "-1"] if strip_metadata

        process_transcoding(path, tempfile, custom_options)
      end
    end

    def process_transcoding(path, tempfile, custom_options)
      movie = FFMPEG::Movie.new(path)
      begin
        movie.transcode(tempfile.path, custom_options) do |progress|
          puts "Progress: #{progress}%"
        end
      rescue => e
        puts "An error occurred during transcoding: #{e.message}"
        return
      end

      yield tempfile if block_given?
    end
  end
end
