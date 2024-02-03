module Mutations::Users
  class SignIn < Mutations::BaseMutation
    graphql_name "signIn"

    argument :login, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true

    def resolve(login:, password:)
      user = User.find_by_email_or_username(login)

      if user&.authenticate(password)
        { token: AuthToken.token(user), user: user }
      else
        raise GraphQL::ExecutionError, "Incorrect login credentials"
      end
    end
  end
end
