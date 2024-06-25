module Types
  class AuthenticatedUserType < BaseObject
    field :id, ID, null: true
    field :email, String, null: true
    field :username, String, null: true
    field :token, String, null: true

    def token
      AuthToken.token(object)
    end
  end
end
