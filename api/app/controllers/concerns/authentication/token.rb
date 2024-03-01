module Authentication
  module Token
    extend ActiveSupport::Concern

    included do
      prepend_before_action :authenticate
      helper_method :current_user
    end

    private

    def authenticate
      return nil if request.headers["Authorization"].blank?
      token = request.headers["Authorization"].split(" ").last
      return nil if token.blank?
      Current.user = AuthToken.verify(token)
    end


    def current_user
      Current.user
    end
  end
end
