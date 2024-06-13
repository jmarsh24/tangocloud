module Mutations::Users
  class RegisterUser < Mutations::BaseMutation
    argument :username, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true

    def resolve(email:, password:, username:)
      user = User.create!(email:, password:, username:)
      UserMailer.with(user:).email_verification.deliver_later
      {user:}
    end
  end
end
