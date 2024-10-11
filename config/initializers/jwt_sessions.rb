JWTSessions.encryption_key =
  if Rails.env.test? || Rails.env.development?
    "stubbed_secret_key_base"
  else
    Rails.application.credentials.secret_key_base
  end

redis_password = ENV["REDIS_PASSWORD"]
redis_host = ENV["REDIS_HOST"]

redis_url =
  if redis_password.present? && redis_host.present?
    "redis://#{redis_password}@#{redis_host}:6379/0"
  else
    "redis://127.0.0.1:6379/0"
  end

JWTSessions.token_store = :redis, {
  redis_url:,
  token_prefix: "jwt_",
  pool_size: Integer(ENV.fetch("RAILS_MAX_THREADS", 5))
}

# Set the access token expiration time to 1 year (in seconds), this disables the need to refresh the token.
# This should be changed in the future.
JWTSessions.access_exp_time = 31_536_000 if Rails.env.development?
