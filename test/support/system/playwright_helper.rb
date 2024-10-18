module PlaywrightHelper
  def pause
    page.driver.with_playwright_page do |playwright_page|
      playwright_page.context.enable_debug_console!
      playwright_page.pause
    end
  end

  def take_screenshot(name)
    return unless ENV["SCREENSHOTS"]

    width = page.current_window.size[0]
    height = page.current_window.size[1]
    save_screenshot("#{name}--desktop.png") # rubocop:disable Lint/Debugger
    page.current_window.resize_to(375, height)
    save_screenshot("#{name}--mobile.png") # rubocop:disable Lint/Debugger
    page.current_window.resize_to(width, height)
  end
end
