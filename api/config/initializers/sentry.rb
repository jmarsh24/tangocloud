require "sentry-ruby"

Sentry.init do |config|
  sentry_environment = Config.sentry_environment || Rails.env
  next unless Rails.env.production? || Rails.env.staging?
  config.dsn = Config.sentry_dsn

  config.breadcrumbs_logger = [:sentry_logger, :http_logger]

  config.environment = sentry_environment
  config.enabled_environments = [sentry_environment].filter_map(&:presence).excluding("development", "test")
  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    0.5
  end
end
