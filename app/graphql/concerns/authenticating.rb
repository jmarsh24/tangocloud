module Authenticating
  extend ActiveSupport::Concern

  included do
    def current_user
      context[:current_user]
    end

    def authenticate_user!
      raise JWTSessions::Errors::Unauthorized, "You need to sign in or sign up before continuing." if current_user.blank?
    end
  end
end
