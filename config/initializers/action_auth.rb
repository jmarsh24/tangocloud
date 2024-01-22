# frozen_string_literal: true

ActionAuth.configure do |config|
  config.webauthn_enabled = true
  config.webauthn_origin = "https://#{Config.host}"
  config.webauthn_rp_name = Rails.application.class.to_s.deconstantize
  config.verify_email_on_sign_in = true
end
