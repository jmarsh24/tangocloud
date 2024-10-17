require "rails_helper"
require "rack_session_access/capybara"

Dir[Rails.root.join("spec/support/system/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by Capybara.javascript_driver
  end

  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.default_sleep_interval = ENV.fetch("RSPEC_RETRY_SLEEP_INTERVAL", 0).to_i
  config.retry_callback = proc do
    Capybara.reset!
  end
end
