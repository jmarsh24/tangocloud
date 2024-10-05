module ExternalCatalog
  module ElRecodo
    class Auth
      BASE_URL = "https://www.el-recodo.com".freeze
      LOGIN_PATH = "/connect?lang=en".freeze

      def initialize(email: nil, password: nil)
        @email = email || Rails.application.credentials.dig(:el_recodo_email)
        @password = password || Rails.application.credentials.dig(:el_recodo_password)
        @connection = Faraday.new(url: BASE_URL) do |faraday|
          faraday.request :retry, max: 3, interval: 0.5, interval_randomness: 0.5, backoff_factor: 2, retry_statuses: [503]
          faraday.response :raise_error
          faraday.headers["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15"
          faraday.headers["Content-Type"] = "application/x-www-form-urlencoded"
          faraday.headers["Accept"] = "*/*"
          faraday.headers["Connection"] = "keep-alive"
        end
      end

      def cookies
        Rails.cache.fetch("el_recodo_cookies", expires_in: 24.hour) do
          response = @connection.post(LOGIN_PATH) do |req|
            req.body = URI.encode_www_form(
              "wish" => "logged",
              "email" => @email,
              "pwd" => @password,
              "autologin" => "1",
              "backurl" => ""
            )
          end
          response.headers["set-cookie"].to_s
        end
      end
    end
  end
end
