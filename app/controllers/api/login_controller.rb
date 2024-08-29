module Api
  class LoginController < BaseController
    before_action :authorize_access_request!, only: [:destroy]

    def create
      user = User.find_by_email_or_username(params[:login])

      if user&.valid_password?(params[:password])
        payload = {user_id: user.id}
        session = JWTSessions::Session.new(payload:)
        render json: session.login
      else
        render json: "Invalid user", status: :unauthorized
      end
    end

    def destroy
      session = JWTSessions::Session.new(payload:)
      session.flush_by_access_payload
      render json: :ok
    end
  end
end
