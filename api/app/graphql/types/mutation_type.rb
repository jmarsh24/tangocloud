module Types
  class MutationType < Types::BaseObject
    field :sign_in, mutation: Mutations::Users::SignIn
    field :sign_up, mutation: Mutations::Users::SignUp
  end
end
