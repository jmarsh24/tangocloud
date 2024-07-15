module Mutations::Users
  class AppleLogin < Mutations::BaseMutation
    include Dry::Monads[:result]
    type Types::LoginResultType, null: false

    argument :user_identifier, String, required: true
    argument :identity_token, String, required: true
    argument :email, String, required: false
    argument :first_name, String, required: false
    argument :last_name, String, required: false

    def resolve(user_identifier:, identity_token:, email: nil, first_name: nil, last_name: nil)
      if email.nil?
        email = AppleToken.new.decode_identity_token(identity_token, user_identifier).dig("email")
      end
      user = User.find_by(email:) || User.find_or_initialize_by(uid: user_identifier)

      if user.new_record?
        user.email = email if email
        user.password = Devise.friendly_token[0, 20]
        user.build_user_preference(first_name:, last_name:)
      end

      user.provider = "apple"
      user.uid = user_identifier
      user.confirmed_at = Time.zone.now

      if user.save
        Success(user)
      else
        Failure(user)
      end
    end
  end
end
