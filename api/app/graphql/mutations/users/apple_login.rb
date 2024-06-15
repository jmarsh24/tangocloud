module Mutations::Users
  class AppleLogin < Mutations::BaseMutation
    argument :user_identifier, String, required: true
    argument :email, String, required: false
    argument :first_name, String, required: false
    argument :last_name, String, required: false

    field :user, Types::UserType, null: true
    field :token, String, null: true

    def resolve(user_identifier:, email: nil, first_name: nil, last_name: nil)
      user = User.find_by(email:) || User.find_or_initialize_by(uid: user_identifier)

      if user.new_record?
        user.email = email if email
        user.build_user_preference(
          first_name:,
          last_name:
        )
      end

      user.provider = "apple"
      user.uid = user_identifier
      user.verified = true

      user.save!
      token = AuthToken.token(user)
      {user:, token:}
    end
  end
end
