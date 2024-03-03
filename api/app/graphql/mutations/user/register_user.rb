module Mutations::User
  class RegisterUser < Mutations::BaseMutation
    graphql_name "register"

    argument :username, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :errors, Types::ValidationErrorsType, null: true

    def resolve(args)
      user = User.new(args)

      if user.save
        UserMailer.with(user:).email_verification.deliver_later

        {user:, success: true}
      else
        {errors: user.errors, success: false}
      end
    end
  end
end
