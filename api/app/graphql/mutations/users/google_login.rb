module Mutations::Users
  class GoogleLogin < Mutations::BaseMutation
    argument :id_token, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true

    def resolve(id_token:)
      google_user_info = Google::Auth::IDTokens.verify_oidc(id_token, aud: Config.google_client_id!)

      email = google_user_info["email"]
      first_name = google_user_info["given_name"]
      last_name = google_user_info["family_name"]
      user_identifier = google_user_info["sub"]
      picture_url = google_user_info["picture"]

      user = User.find_by(email:) || User.find_or_initialize_by(uid: user_identifier)

      if user.new_record?
        user.email = email if email
        user.build_user_preference(first_name:, last_name:)
      end

      if !user.user_preference.avatar.attached?
        response = Faraday.get(picture_url)
        if response.success?
          file = StringIO.new(response.body)
          filename = File.basename(URI.parse(picture_url).path)
          user.user_preference.avatar.attach(io: file, filename:)
        end
      end

      user.provider = "google"
      user.uid = user_identifier
      user.verified = google_user_info["email_verified"]

      user.save!
      token = AuthToken.token(user)
      {user:, token:}
    end
  end
end