require "sentry-ruby"

Sentry.init do |config|
  sentry_environment = Config.sentry_environment || Rails.env
  next unless Rails.env.production? || Rails.env.staging?
  config.dsn = Config.sentry_dsn

  config.breadcrumbs_logger = [:sentry_logger, :http_logger]

  config.environment = sentry_environment
  config.enabled_environments = [sentry_environment].filter_map(&:presence).excluding("development", "test")

  # Adjust traces sampler to exclude /up transactions
  config.traces_sampler = lambda do |sampling_context|
    transaction_context = sampling_context[:transaction_context]
    op = transaction_context[:op]
    transaction_name = transaction_context[:name]

    # Exclude /up transactions
    if op == 'http.server' && transaction_name == '/up'
      0.0
    else
      0.5
    end
  end

  config.traces_sample_rate = 1.0 # Ensure this is set as a fallback
end
