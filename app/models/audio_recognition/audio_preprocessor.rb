class AudioPreprocessor
  def process(audio_file)
    Tempfile.create(["processed_audio", ".mp3"]) do |output_file|
      FFMPEG::Movie.new(audio_file.path).transcode(
        output_file.path,
        audio_transcoding_options
      )

      yield output_file if block_given?
    rescue => e
      Rails.logger.error("AudioPreprocessor Error: #{e.message}")
      raise "Failed to process audio file"
    end
  end

  private

  def audio_transcoding_options
    {
      audio_codec: "libmp3lame", # Use MP3 codec
      audio_bitrate: "128k",     # Adjust bitrate if needed
      audio_sample_rate: 44100,  # Sample rate
      seek_time: 0,              # Start trimming from 0 seconds
      duration: 30               # Trim to 30 seconds
    }
  end
end
