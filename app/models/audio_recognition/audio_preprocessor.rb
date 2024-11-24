class AudioPreprocessor
  def process(audio_file, seek_time)
    movie = FFMPEG::Movie.new(audio_file.path)

    Tempfile.create(["processed_audio", ".mp3"]) do |output_file|
      Rails.logger.info("Processing audio: Seeking #{seek_time} seconds")

      movie.transcode(
        output_file.path,
        audio_transcoding_options(seek_time)
      )

      yield output_file if block_given?
    end
  rescue => e
    Rails.logger.error("AudioPreprocessor Error: #{e.message}")
    raise "Audio preprocessing failed: #{e.message}"
  end

  private

  def audio_transcoding_options(seek_time)
    {
      audio_codec: "libmp3lame", # Use MP3 codec
      audio_bitrate: "128k",     # Adjust bitrate if needed
      audio_sample_rate: 44100,  # Sample rate
      seek_time: seek_time,      # Start from specified seek time
      duration: 15               # Trim to 15 seconds
    }
  end
end
