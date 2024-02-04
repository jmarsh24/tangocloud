class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :set_current_request_details
  before_action :authenticate
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def current_user
    @current_user ||= Current.user || AuthToken.verify(request.headers["Authorization"])
  end

  def authenticate
    if (session_record = Session.find_by_id(cookies.signed[:session_token]))
      Current.session = session_record
    else
      # redirect_to sign_in_path
    end
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end

  def user_not_authorized(exception)
    head :unauthorized
  end
end
