require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"
require "mime/types"
require "faraday"
require "faraday/retry"

require_relative "../lib/middleware/silent_logger_middleware"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Config = Shimmer::Config.instance # rubocop:disable Style/MutableConstant

module Tangocloud
  class Application < Rails::Application
    config.middleware.insert_before Rails::Rack::Logger, Middleware::SilentLoggerMiddleware
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.

    [:tracking, :user].each do |folder|
      config.autoload_paths += Dir[Rails.root.join("app", "models", folder.to_s, "**/")]
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.active_job.queue_adapter = :solid_queue
    config.solid_queue.connects_to = {database: {writing: :queue}}

    config.cache_store = :solid_cache_store

    host = Config.host(default: "localhost:3000")
    Rails.application.routes.default_url_options[:host] = host
    config.action_mailer.default_url_options = {host:}

    config.active_storage.variant_processor = :vips
    config.mission_control.jobs.base_controller_class = "AdminController"

    config.active_storage.queue = :low_priority
  end
end
