module Authentication
  module Token
    extend ActiveSupport::Concern

    included do
      prepend_before_action :authenticate!
    end

    private

    def authenticate!
      token = request.headers["Authorization"].to_s.split(" ").last
      Current.user = AuthToken.verify(token) if token.present?

      unless Current.user
        render json: {errors: ["You must be signed in to access this resource."]}, status: :unauthorized
        false
      end
    end

    def current_user
      Current.user
    end
  end
end
