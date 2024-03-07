module Mutations::Users
  class LoginUser < Mutations::BaseMutation
    argument :login, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :success, Boolean, null: false
    field :errors, [Types::ErrorType], null: true

    def resolve(login:, password:)
      user = User.find_by_email_or_username(login)
      if user&.authenticate(password)
        context[:current_user] = user
        {
          token: AuthToken.token(user),
          user:,
          success: true,

          errors: []
        }
      else
        context[:current_user] = nil
        {
          user: nil,
          token: nil,
          success: false,
          errors: [
            {
              message: "Incorrect Email/Password"
            }
          ]
        }
      end
    end
  end
end
