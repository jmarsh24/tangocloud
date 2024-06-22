module Authentication
  module Cookies
    extend ActiveSupport::Concern

    private

    def current_user
      Current.user
    end

    def require_admin!
      current_user&.admin?
    end

    def authenticate_user!
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
end
