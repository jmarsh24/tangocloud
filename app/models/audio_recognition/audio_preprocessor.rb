class AudioPreprocessor
  def process(audio_file)
    Tempfile.create(["processed_audio", ".mp3"]) do |output_file|
      FFMPEG::Movie.new(audio_file.path).transcode(
        output_file.path,
        audio_transcoding_options(audio_file)
      )

      yield output_file if block_given?
    rescue => e
      Rails.logger.error("AudioPreprocessor Error: #{e.message}")
      raise "Failed to process audio file"
    end
  end

  private

  def audio_transcoding_options(audio_file)
    {
      audio_codec: "libmp3lame", # Use MP3 codec
      audio_bitrate: "128k",     # Adjust bitrate if needed
      audio_sample_rate: 44100,  # Sample rate
      seek_time: center_of_audio(audio_file), # Start from the center
      duration: 15               # Trim to 10 seconds
    }
  end

  def center_of_audio(audio_file)
    movie = FFMPEG::Movie.new(audio_file.path)
    movie.duration / 2
  end
end
