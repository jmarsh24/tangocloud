module CupriteHelper
  def pause
    Capybara.current_session.driver.with_playwright_page do |page|
      page.context.enable_debug_console!
      page.pause
    end
  end

  def screenshot(name)
    return unless Rails.application.credentials.dig(:screenshot)

    width = page.current_window.size[0]
    height = page.current_window.size[1]
    super("#{name}--desktop")
    page.current_window.resize_to(375, height)
    super("#{name}--mobile")
    page.current_window.resize_to(width, height)
  end
end

RSpec.configure do |config|
  # config.include Capybara::Screenshot::Diff::TestMethods, type: :system
  config.include CupriteHelper, type: :system
end
