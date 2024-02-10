module Api
  class ApplicationController < ActionController::Base
    # include Pundit::Authorization
    skip_before_action :verify_authenticity_token
    # after_action :verify_authorized
    # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def current_user
      return nil if request.headers["Authorization"].blank?
      token = request.headers["Authorization"].split(" ").last
      return nil if token.blank?
      Current.user = AuthToken.verify(token)
    end

    def user_not_authorized(exception)
      head :unauthorized
    end
  end
end
