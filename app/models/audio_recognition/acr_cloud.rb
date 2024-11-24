class AcrCloud
  BASE_URL = "https://identify-eu-west-1.acrcloud.com/v1/identify"
  MAX_RETRIES = 3
  RETRY_SEEK_OFFSETS = [0, 10, -10, 30, -30]

  def initialize
    @client = Faraday.new(url: BASE_URL) do |conn|
      conn.request :multipart
      conn.request :url_encoded
      conn.response :json, parser_options: {symbolize_names: true}
      conn.adapter Faraday.default_adapter
    end
  end

  def recognize(audio_file)
    movie = FFMPEG::Movie.new(audio_file.path)
    duration = movie.duration

    safe_start = [10, duration * 0.05].max
    safe_end = [duration - 10, duration * 0.95].min
    center = duration / 2

    seek_times = [
      center,
      safe_start,
      safe_end
    ] + RETRY_SEEK_OFFSETS.map { |offset| (center + offset).clamp(safe_start, safe_end) }

    seek_times.uniq.first(MAX_RETRIES).each_with_index do |seek_time, index|
      Rails.logger.info("ACRCloud attempt #{index + 1}: Seeking #{seek_time} seconds")

      result = process_and_recognize(audio_file, seek_time)

      return result if result[:success]

      Rails.logger.warn("Recognition failed for attempt #{index + 1}: #{result[:error] || "No result"}")
    end

    {success: false, error: "No match found after #{MAX_RETRIES} attempts", error_code: 1001}
  end

  private

  def process_and_recognize(audio_file, seek_time)
    AudioPreprocessor.new.process(audio_file, seek_time) do |audio_snippet|
      sample_bytes = File.size(audio_snippet.path)

      response = @client.post do |req|
        req.headers["Content-Type"] = "multipart/form-data"

        req.body = {
          "sample" => Faraday::UploadIO.new(audio_snippet.path, "audio/mpeg"),
          "access_key" => Rails.application.credentials.dig(:acr_cloud, :access_key),
          "data_type" => "audio",
          "signature_version" => "1",
          "signature" => generate_signature,
          "sample_bytes" => sample_bytes,
          "timestamp" => Time.now.to_i
        }
      end

      parsed_response = JSON.parse(response.body).deep_symbolize_keys

      if parsed_response[:status][:code] == 0
        {success: true, metadata: parsed_response[:metadata]}
      else
        {
          success: false,
          error: parsed_response[:status][:msg],
          error_code: parsed_response[:status][:code]
        }
      end
    end
  end

  def generate_signature
    access_key = Rails.application.credentials.dig(:acr_cloud, :access_key)
    access_secret = Rails.application.credentials.dig(:acr_cloud, :access_secret)
    timestamp = Time.now.to_i
    data = ["POST", "/v1/identify", access_key, "audio", "1", timestamp].join("\n")

    digest = OpenSSL::Digest.new("sha1")
    Base64.strict_encode64(OpenSSL::HMAC.digest(digest, access_secret, data))
  end
end
