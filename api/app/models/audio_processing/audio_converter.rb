module AudioProcessing
  class AudioConverter
    attr_reader :file, :format, :bitrate, :sample_rate, :channels, :codec, :output_directory

    DEFAULT_OPTIONS = {
      format: "aac",
      bitrate: "320k",
      sample_rate: 48000,
      channels: 1,
      codec: "aac_at",
      output_directory: "tmp/converted_audio_files",
      filename: nil
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
    end

    def convert
      ensure_output_directory_exists
      output = generate_output_filename
      movie = FFMPEG::Movie.new(file)

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

      movie.transcode(output, custom_options) do |progress|
        puts progress
      end

      yield output if block_given?
      output
    rescue FFMPEG::Error => e
      puts "Failed to convert file: #{e.message}"
      nil
    end

    private

    def ensure_output_directory_exists
      Dir.mkdir(output_directory) unless Dir.exist?(output_directory)
    end

    def generate_output_filename
      basename = @filename || File.basename(file, ".*")
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      "#{@output_directory}/#{basename}_#{timestamp}.#{format}"
    end

    def extract_cover_art
      cover_art_path = "#{output_directory}/cover_art.jpg"
      command = "ffmpeg -i #{@file} -an -vcodec copy #{cover_art_path}"
      system(command)
      File.exist?(cover_art_path) ? cover_art_path : nil
    rescue => e
      puts "Failed to extract cover art: #{e.message}"
      nil
    end
  end
end
