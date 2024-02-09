module Api
  class ApplicationController < ActionController::Base
    include Pundit::Authorization
    after_action :verify_authorized
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    before_action :authenticate

    private

    def authenticate
      token = request.headers["Authorization"]&.split(" ")&.last
      if token
        begin
          Current.user = AuthToken.verify(token)
        rescue ActiveRecord::RecordNotFound, JWT::DecodeError
          head :unauthorized
        end
      else
        head :unauthorized
      end
    end

    def current_user
      Current.user
    end

    def user_not_authorized(exception)
      head :unauthorized
    end
  end
end
