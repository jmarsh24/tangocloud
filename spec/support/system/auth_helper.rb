module AuthHelper
  def sign_in(user)
    post login_path, params: {email: user.email, password: "password"}

    if defined?(page) && Capybara.current_driver
      cookies = ActionDispatch::Request.new(Rails.application.env_config.deep_dup).cookie_jar
      page.driver.browser.set_cookie(cookies.to_cookie_string)
    end
  end

  def sign_out
    delete logout_path

    if defined?(page) && Capybara.current_driver
      page.driver.browser.clear_cookies
    end
  end

  def user_signed_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :system
  config.include AuthHelper, type: :request
end
