module Authenticable
  extend ActiveSupport::Concern

  included do
    prepend_before_action :set_current_request_details
    prepend_before_action :authenticate
    helper_method :current_user
  end

  private

  def current_user
    Current.user
  end

  def authenticate
    if (session_record = Session.find_by_id(cookies.signed[:session_token]))
      Current.session = session_record
      Current.user = Current.session&.user
    else
      redirect_to sign_in_path
    end
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end
end
