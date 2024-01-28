# frozen_string_literal: true

module Mutations
  class UserLogin < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(email:, password:)
      user = User.find_for_authentication(email: email)
      return unless user&.valid_password?(password)

      token = JsonWebToken.encode(user_id: user.id)
      { user: user, token: token }
    end
  end
end
