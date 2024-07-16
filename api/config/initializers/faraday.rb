Faraday.default_connection = Faraday.new do |conn|
  conn.response :raise_error
end
