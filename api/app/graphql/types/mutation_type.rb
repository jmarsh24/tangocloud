module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::User::LoginUser
    field :register, mutation: Mutations::User::RegisterUser

    field :add_like_to_recording, mutation: Mutations::Recording::AddLikeToRecording
    field :remove_like_from_recording, mutation: Mutations::Recording::RemoveLikeFromRecording
    field :create_listen, mutation: Mutations::Listen::CreateListen
    field :destroy_listen, mutation: Mutations::Listen::RemoveListen
  end
end
