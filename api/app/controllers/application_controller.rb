class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :set_current_request_details
  before_action :authenticate
  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authenticate
    if (session_record = Session.find_by(id: cookies.signed[:session_token]))
      Current.session = session_record
      Current.user = session_record.user
    elsif request.headers["Authorization"].present?
      authenticate_with_jwt
    else
      redirect_to sign_in_path
    end
  end

  def authenticate_with_jwt
    token = request.headers["Authorization"].to_s.split(" ").last
    user = AuthToken.verify(token)
    Current.user = user if user
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end

  def user_not_authorized(exception)
    head :unauthorized
  end

  def current_user
    Current.user
  end
end
