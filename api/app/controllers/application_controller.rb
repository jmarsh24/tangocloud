class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Authentication::Cookies

  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    flash[:alert] = I18n.t "pundit.not_authorized"
    redirect_back(fallback_location: sign_in_path)
  end
end
