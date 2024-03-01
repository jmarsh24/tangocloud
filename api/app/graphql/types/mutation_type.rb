module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Users::Login
    field :register, mutation: Mutations::Users::Register
  end
end
