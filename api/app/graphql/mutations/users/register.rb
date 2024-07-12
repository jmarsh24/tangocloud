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
          payload = {user_id: user.id}
          session = JWTSessions::Session.new(payload:, refresh_by_access_allowed: true)
          tokens = session.login

          Success(
            user:,
            access: tokens[:access],
            csrf: tokens[:csrf]
          )
        else
          Failure(messages: user.errors.full_messages)
        end
      end
    end
  end
end
