module Mutations
  module Users
    class Login < Mutations::BaseMutation
      include Dry::Monads[:result]
      type Types::LoginResult, null: false

      argument :login, String, required: true
      argument :password, String, required: true

      def resolve(login:, password:)
        user = User.find_by_email_or_username(login)

        if user&.valid_password?(password)
          Success(user)
        else
          Failure(message: "Invalid email or password")
        end
      end
    end
  end
end
