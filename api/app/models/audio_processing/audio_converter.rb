module AudioProcessing
  class AudioConverter
    attr_reader :file, :format, :bitrate, :sample_rate, :channels, :codec, :movie, :output_directory

    DEFAULT_OPTIONS = {
      format: "aac",
      bitrate: "320k",
      sample_rate: 48000,
      channels: 1,
      codec: "aac_at",
      output_directory: "tmp/converted_audio_files",
      filename: nil,
      strip_metadata: true
    }.freeze

    def initialize(file:, **options)
      options = DEFAULT_OPTIONS.merge(options)
      @file = file.to_s
      @format = options[:format]
      @bitrate = options[:bitrate]
      @sample_rate = options[:sample_rate]
      @channels = options[:channels]
      @codec = options[:codec]
      @output_directory = options[:output_directory]
      @filename = options[:filename]
      @movie = FFMPEG::Movie.new(file.to_s)
      @strip_metadata = options[:strip_metadata]
    end

    def convert
      Dir.mkdir(output_directory) unless Dir.exist?(output_directory)
      permanent_file_path = nil

      Tempfile.create([@filename || File.basename(file, ".*"), ".#{format}"], output_directory) do |tempfile|
        output = tempfile.path

        codec = Config.ci? ? "aac" : @codec

        custom_options = [
          "-i", file,                          # Input audio file
          "-map", "0:a:0",                     # Map the first (audio) stream from the first input (audio file)
          "-codec:a", codec,                   # Audio codec
          "-b:a", bitrate,                     # Audio bitrate (enforce 320k)
          "-ar", sample_rate.to_s,             # Audio sample rate
          "-ac", channels.to_s,                # Number of audio channels
          "-movflags", "+faststart",           # Fast start for streaming
          "-id3v2_version", "3"                # Ensure compatibility with ID3v2
        ]

        custom_options += ["-map_metadata", "-1"] if @strip_metadata

        @movie.transcode(output, custom_options) do |progress|
          puts progress
        end

        yield output if block_given?

        permanent_filename = @filename || "#{File.basename(file, File.extname(file))}_converted.#{format}"
        permanent_file_path = File.join(output_directory, permanent_filename)
        FileUtils.copy_file(output, permanent_file_path)
        permanent_file_path
      end
    rescue FFMPEG::Error => e
      puts "Failed to convert file: #{e.message}"
      nil
    end
  end
end
