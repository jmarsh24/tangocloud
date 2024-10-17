Capybara.register_driver(:playwright) do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: :chromium,
    headless: true)
end

Capybara.default_driver = Capybara.javascript_driver = :playwright
Capybara.enable_aria_label = true
