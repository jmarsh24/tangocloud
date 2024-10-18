require "test_helper"

Capybara.register_driver :my_playwright do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: ENV["PLAYWRIGHT_BROWSER"]&.to_sym || :chromium,
    headless: (false unless ENV["CI"] || ENV["PLAYWRIGHT_HEADLESS"]))
end

Dir[Rails.root.join("test/support/system/*.rb")].sort.each { |f| require f }

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include AuthHelper
  include TurboHelper

  driven_by :my_playwright
end

Capybara.default_max_wait_time = 5
