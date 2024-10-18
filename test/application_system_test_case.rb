require "test_helper"

Capybara.register_driver :my_playwright do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: ENV["PLAYWRIGHT_BROWSER"]&.to_sym || :chromium,
    headless: (false unless ENV["CI"] || ENV["PLAYWRIGHT_HEADLESS"]))
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :my_playwright

  def sign_in_as(user)
    visit sign_in_url
    fill_in :email, with: user.email
    fill_in :password, with: "Secret1*3*5*"
    click_on "Sign in"

    assert_current_path root_url
    user
  end

  def wait_for_turbo(timeout = 2)
    if has_css?(".turbo-progress-bar", visible: true, wait: 0.25.seconds)
      has_no_css?(".turbo-progress-bar", wait: timeout)
    end
  end

  def wait_for_turbo_stream_connected(streamable: nil)
    if streamable
      signed_stream_name = Turbo::StreamsChannel.signed_stream_name(streamable)
      assert_selector("turbo-cable-stream-source[connected][channel=\"Turbo::StreamsChannel\"][signed-stream-name=\"#{signed_stream_name}\"]", visible: :all)
    else
      assert_selector("turbo-cable-stream-source[connected][channel=\"Turbo::StreamsChannel\"]", visible: :all)
    end
  end
end

Capybara.default_max_wait_time = 5 # Set the wait time in seconds
