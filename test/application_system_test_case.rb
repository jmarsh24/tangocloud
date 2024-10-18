require "test_helper"

Dir[Rails.root.join("spec/support/system/*.rb")].sort.each { |f| require f }

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :my_playwright

  setup do
    page.driver.start_tracing(title: name, screenshots: true, snapshots: true)
  end

  teardown do
    if !passed? && ENV["SCREENSHOTS"]
      take_screenshot("failure-#{name.parameterize}")
    end

    if !passed?
      trace_path = Rails.root.join("tmp/playwright/traces/#{name.parameterize}.zip")
      page.driver.stop_tracing(path: trace_path)
      puts "View failed trace: npx playwright show-trace #{trace_path}"
    else
      page.driver.stop_tracing
    end
  end
end

Capybara.default_max_wait_time = 5
