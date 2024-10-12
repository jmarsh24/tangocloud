Imgproxy.configure do |config|
  config.endpoint = ENV["IMGPROXY_ENDPOINT"]
  config.key = ENV["IMGPROXY_KEY"]
  config.salt = ENV["IMGPROXY_SALT"]
end
