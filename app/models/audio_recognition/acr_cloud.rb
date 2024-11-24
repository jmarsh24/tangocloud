class AcrCloud
  BASE_URL = "https://identify-eu-west-1.acrcloud.com/v1/identify"

  def initialize
    @client = Faraday.new(url: BASE_URL) do |conn|
      conn.request :multipart
      conn.request :url_encoded
      conn.response :json, parser_options: {symbolize_names: true}
      conn.adapter Faraday.default_adapter
    end
  end

  def recognize(audio_file)
    access_key = Rails.application.credentials.dig(:acr_cloud, :access_key)
    access_secret = Rails.application.credentials.dig(:acr_cloud, :access_secret)
    data_type = "audio"
    signature_version = "1"
    timestamp = Time.now.to_i

    string_to_sign = [
      "POST",
      "/v1/identify",
      access_key,
      data_type,
      signature_version,
      timestamp
    ].join("\n")

    digest = OpenSSL::Digest.new("sha1")
    signature = Base64.strict_encode64(OpenSSL::HMAC.digest(digest, access_secret, string_to_sign))

    AudioPreprocessor.new.process(audio_file) do |audio_snippet|
      sample_bytes = File.size(audio_snippet.path)

      response = @client.post do |req|
        req.headers["Content-Type"] = "multipart/form-data"

        req.body = {
          "sample" => Faraday::UploadIO.new(audio_snippet.path, "audio/mpeg"),
          "access_key" => access_key,
          "data_type" => data_type,
          "signature_version" => signature_version,
          "signature" => signature,
          "sample_bytes" => sample_bytes,
          "timestamp" => timestamp
        }
      end

      parsed_response = JSON.parse(response.body).deep_symbolize_keys

      if parsed_response[:status][:code] == 0
        {
          success: true,
          metadata: parsed_response[:metadata]
        }
      else
        {
          success: false,
          error_code: parsed_response[:status][:code],
          error: parsed_response[:status][:msg],
          status: parsed_response[:status][:code]
        }
      end
    end
  rescue Faraday::Error => error
    Rails.logger.error("ACRCloud Error: #{error.message}")
    {
      success: false,
      error: error.message,
      status: nil
    }
  end
end
