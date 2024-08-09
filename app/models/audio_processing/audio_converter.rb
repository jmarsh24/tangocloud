module AudioProcessing
  class AudioConverter
    attr_reader :format, :bitrate, :sample_rate, :channels, :codec, :output_dir

    DEFAULT_OPTIONS = {
      format: "mp3",
      bitrate: "256k",
      sample_rate: 48000,
      channels: 2,
      codec: "mp3",
      strip_metadata: true
    }.freeze

    def initialize(output_dir: nil, **options)
      options = DEFAULT_OPTIONS.merge(options)
      @format = options[:format]
      @bitrate = options[:bitrate]
      @sample_rate = options[:sample_rate]
      @channels = options[:channels]
      @codec = options[:codec]
      @strip_metadata = options[:strip_metadata]
      @output_dir = output_dir
    end

    def convert(file:)
      @output_dir ||= File.dirname(file.path)
      movie = FFMPEG::Movie.new(file.path)

      Tempfile.create(["converted-", ".#{format}"]) do |tempfile|
        custom_options = [
          "-map", "0:a:0",           # Map the first (audio) stream from the first input (audio file)
          "-codec:a", codec,         # Audio codec
          "-b:a", bitrate,           # Audio bitrate (enforce 256k for high quality)
          "-ar", sample_rate.to_s,   # Audio sample rate
          "-ac", channels.to_s,      # Number of audio channels (2 for stereo)
          "-movflags", "+faststart", # Fast start for streaming
          "-id3v2_version", "3"      # Ensure compatibility with ID3v2
        ]

        custom_options += ["-map_metadata", "-1"] if @strip_metadata

        movie.transcode(tempfile.path, custom_options) do |progress|
          puts progress
        end

        # Returning the tempfile for further processing
        yield tempfile if block_given?
      end
    end
  end
end
