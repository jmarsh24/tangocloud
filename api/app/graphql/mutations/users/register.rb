module Mutations
  module Users
    class Register < Mutations::BaseMutation
      include Dry::Monads[:result]
      type Types::RegistrationResult, null: false

      argument :email, String, required: true
      argument :password, String, required: true
      argument :username, String, required: false

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
