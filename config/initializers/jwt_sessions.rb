JWTSessions.encryption_key =
  if Rails.env.test? || Rails.env.development?
    "stubbed_secret_key_base"
  else
    Rails.application.credentials.secret_key_base
  end

JWTSessions.token_store = :redis, {
  redis_host: "127.0.0.1",
  redis_port: "6379",
  redis_db_name: "0",
  token_prefix: "jwt_",
  pool_size: Integer(ENV.fetch("RAILS_MAX_THREADS", 5))
}

# Set the access token expiration time to 1 year (in seconds), this disables the need to refresh the token.
# This should be changed in the future.
JWTSessions.access_exp_time = 31_536_000 if Rails.env.development?
