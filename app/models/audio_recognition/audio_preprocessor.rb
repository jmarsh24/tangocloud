class AudioPreprocessor
  MAX_RETRIES = 3
  RETRY_SEEK_OFFSETS = [10, -10, 30] # Time offsets in seconds to try around the center

  def process(audio_file)
    movie = FFMPEG::Movie.new(audio_file.path)
    duration = movie.duration

    # Ensure we avoid silence at the start and end
    safe_start = [10, duration * 0.05].max # 5% of duration or 10 seconds
    safe_end = [duration - 10, duration * 0.95].min # Last 5% or 10 seconds before end
    center = duration / 2

    attempts = [
      {seek_time: center, label: "center"},
      {seek_time: safe_start, label: "start"},
      {seek_time: safe_end, label: "end"}
    ] + RETRY_SEEK_OFFSETS.map do |offset|
      {seek_time: [center + offset, safe_start].max.clamp(safe_start, safe_end), label: "offset #{offset}"}
    end

    Tempfile.create(["processed_audio", ".mp3"]) do |output_file|
      attempts.each_with_index do |attempt, index|
        Rails.logger.info("Processing attempt #{index + 1}: Seeking #{attempt[:label]} (#{attempt[:seek_time]} seconds)")

        movie.transcode(
          output_file.path,
          audio_transcoding_options(attempt[:seek_time])
        )

        result = yield output_file if block_given?

        return result if result[:success]

        Rails.logger.warn("Recognition failed for attempt #{index + 1}: #{result[:error] || "No result"}")
      rescue => e
        Rails.logger.error("AudioPreprocessor Error in attempt #{index + 1}: #{e.message}")
      end
    end

    raise "Audio recognition failed after #{attempts.size} attempts"
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
