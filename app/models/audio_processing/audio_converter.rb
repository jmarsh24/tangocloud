# frozen_string_literal: true

module AudioProcessing
  class AudioConverter
    attr_reader :file, :format, :bitrate, :sample_rate, :channels, :codec, :output_directory

    DEFAULT_OPTIONS = {
      format: "aac",
      bitrate: "320k",
      sample_rate: 48000,
      channels: 1,
      codec: "aac_at",
      output_directory: "converted_audio_files",
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

      conversion_options = {
        audio_codec: codec,
        audio_bitrate: bitrate,
        audio_sample_rate: sample_rate,
        audio_channels: channels,
        custom: ["-movflags", "+faststart"]
      }

      movie.transcode(output, conversion_options) do |progress|
        puts progress
      end

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
      dir = File.dirname(file)
      basename = File.basename(file, ".*")
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      "#{dir}/#{basename}_#{timestamp}.#{format}"
    end
  end
end
