module Mutations::Users
  class SignIn < Mutations::BaseMutation
    graphql_name "signIn"

    argument :login, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true

    def resolve(login:, password:)
      user = User.find_by_email_or_username(login)
      errors = {}

      if user&.authenticate(password)
        context[:current_user] = user
        token = AuthToken.token(user)

        {token: AuthToken.token(user), user:, success: true}
      else
        user = nil
        context[:current_user] = nil

        raise GraphQL::ExecutionError, "Incorrect Email/Password"
      end
    end
  end
end
