module PlaywrightHelper
  def pause
    Capybara.current_session.driver.with_playwright_page do |page|
      page.context.enable_debug_console!
      page.pause
    end
  end

  def screenshot(name)
    return unless ENV["SCREENSHOTS"]

    width = page.current_window.size[0]
    height = page.current_window.size[1]
    super("#{name}--desktop")
    page.current_window.resize_to(375, height)
    super("#{name}--mobile")
    page.current_window.resize_to(width, height)
  end
end

RSpec.configure do |config|
  config.include PlaywrightHelper, type: :system
  config.before(:each, type: :system) do |example|
    page.driver.start_tracing(title: example.metadata[:full_description], screenshots: true, snapshots: true)
  end
  config.after(:each, type: :system) do |example|
    if example.exception
      path = Rails.root.join("tmp/playwright/traces/#{example.metadata[:full_description].parameterize}.zip")
      page.driver.stop_tracing(path:)
      puts "View failed trace: npx playwright show-trace #{path}"
    else
      page.driver.stop_tracing
    end
  end
end
