class ApplicationController < ActionController::Base
  include Shimmer::FileHelper
  include Pundit::Authorization
  include Authentication::Cookies

  before_action :set_current_request_details
  before_action :authenticate_user!

  after_action :verify_authorized

  helper_method :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    flash[:alert] = I18n.t("pundit.not_authorized")
    redirect_back(fallback_location: sign_in_path)
  end
end
