module Api
  class SessionsController < BaseController
    before_action :authorize_access_request!, only: [:destroy]

    # @route POST /api/login (api_login)
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

    # @route POST /api/google_login (api_google_login)
    def google_login
      id_token = params[:id_token]
      google_user_info = Google::Auth::IDTokens.verify_oidc(id_token, aud: Rails.application.credentials.dig(:google_client_id))

      email = google_user_info["email"]
      first_name = google_user_info["given_name"]
      last_name = google_user_info["family_name"]
      user_identifier = google_user_info["sub"]
      picture_url = google_user_info["picture"]

      user = User.find_by(email:) || User.find_or_initialize_by(uid: user_identifier)

      if user.new_record?
        user.email = email if email
        user.password = Devise.friendly_token[0, 20]
        user.build_user_preference(first_name:, last_name:)
      end

      attach_google_avatar(user, picture_url) unless user.user_preference.avatar.attached?

      user.provider = "google"
      user.uid = user_identifier
      user.confirmed_at = Time.zone.now

      if user.save
        render json: generate_session(user), status: :ok
      else
        render json: {error: "Failed to login with Google"}, status: :unauthorized
      end
    end

    # @route POST /api/apple_login (api_apple_login)
    def apple_login
      user_identifier = params[:user_identifier]
      identity_token = params[:identity_token]
      email = params[:email] || AppleToken.new.decode_identity_token(identity_token, user_identifier).dig("email")

      user = User.find_by(email:) || User.find_or_initialize_by(uid: user_identifier)

      if user.new_record?
        user.email = email if email
        user.password = Devise.friendly_token[0, 20]
        user.build_user_preference(first_name: params[:first_name], last_name: params[:last_name])
      end

      user.provider = "apple"
      user.uid = user_identifier
      user.confirmed_at = Time.zone.now

      if user.save
        render json: generate_session(user), status: :ok
      else
        render json: {error: "Failed to login with Apple"}, status: :unauthorized
      end
    end

    # @route DELETE /api/logout (api_logout)
    def destroy
      session = JWTSessions::Session.new(payload:)
      session.flush_by_access_payload
      render json: :ok
    end

    private

    def attach_google_avatar(user, picture_url)
      response = Faraday.get(picture_url)
      return unless response.success?

      file = StringIO.new(response.body)
      filename = File.basename(URI.parse(picture_url).path)
      user.user_preference.avatar.attach(io: file, filename:)
    end

    def generate_session(user)
      payload = {user_id: user.id}
      session = JWTSessions::Session.new(payload:, refresh_by_access_allowed: true)
      tokens = session.login

      {
        id: user.id,
        email: user.email,
        username: user.username,
        session: {
          access: tokens[:access],
          access_expires_at: Time.at(tokens[:access_expires_at]),
          refresh: tokens[:refresh],
          refresh_expires_at: Time.at(tokens[:refresh_expires_at])
        }
      }
    end
  end
end
