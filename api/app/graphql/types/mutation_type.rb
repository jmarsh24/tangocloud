module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Users::Login
    field :register, mutation: Mutations::Users::Register

    field :create_like, mutation: Mutations::UserActivity::CreateLike
    field :create_listen, mutation: Mutations::UserActivity::CreateListen
    field :destry_like, mutation: Mutations::UserActivity::DestroyLike
    field :destroy_listen, mutation: Mutations::UserActivity::DestroyListen
  end
end
