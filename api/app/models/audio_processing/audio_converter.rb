require "tempfile"
require "streamio-ffmpeg"

module AudioProcessing
  class AudioConverter
    attr_reader :file, :format, :bitrate, :sample_rate, :channels, :codec, :filename, :movie

    DEFAULT_OPTIONS = {
      format: "aac",
      bitrate: "320k",
      sample_rate: 48000,
      channels: 1,
      codec: "aac",
      strip_metadata: true
    }.freeze

    def initialize(file:, output_dir: nil, **options)
      options = DEFAULT_OPTIONS.merge(options)
      @file = file.is_a?(String) ? File.open(file) : file
      @format = options[:format]
      @bitrate = options[:bitrate]
      @sample_rate = options[:sample_rate]
      @channels = options[:channels]
      @codec = options[:codec]
      @strip_metadata = options[:strip_metadata]
      @output_dir = output_dir || File.dirname(@file.path)
      @filename = "#{File.basename(@file, File.extname(@file))}.#{format}"
      @movie = FFMPEG::Movie.new(@file.path)
    end

    def convert
      tempfile = Tempfile.new(["converted-", ".#{format}"])
      custom_options = [
        "-map", "0:a:0",           # Map the first (audio) stream from the first input (audio file)
        "-codec:a", codec,         # Audio codec
        "-b:a", bitrate,           # Audio bitrate (enforce 320k)
        "-ar", sample_rate.to_s,   # Audio sample rate
        "-ac", channels.to_s,      # Number of audio channels
        "-movflags", "+faststart", # Fast start for streaming
        "-id3v2_version", "3"      # Ensure compatibility with ID3v2
      ]

      custom_options += ["-map_metadata", "-1"] if @strip_metadata

      @movie.transcode(tempfile.path, custom_options) do |progress|
        puts progress
      end

      tempfile
    end
  end
end
