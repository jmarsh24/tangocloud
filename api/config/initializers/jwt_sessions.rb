JWTSessions.encryption_key =
  if Rails.env.test? || Rails.env.development?
    Config.secret_key_base || "stubbed_secret_key_base"
  else
    Config.secret_key_base
  end
