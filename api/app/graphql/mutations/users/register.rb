module Mutations
  module Users
    class Register < Mutations::BaseMutation
      include Dry::Monads[:result]
      type Types::RegistrationResult, null: false

      argument :username, String, required: false
      argument :email, String, required: true
      argument :password, String, required: true

      def resolve(email:, username:, password:)
        user = User.new(
          username:,
          email:,
          password:
        )

        if user.save
          Success(user)
        else
          Failure(user)
        end
      end
    end
  end
end
