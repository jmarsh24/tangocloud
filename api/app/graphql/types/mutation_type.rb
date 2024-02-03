module Types
  class MutationType < Types::BaseObject
    field :sign_up, mutation: Mutations::Users::SignUp
    field :sign_in, mutation: Mutations::Users::SignIn
  end
end
