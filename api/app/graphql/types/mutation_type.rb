module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Users::Login
    field :register, mutation: Mutations::Users::Register

    field :create_like, mutation: Mutations::UserActivity::CreateLike
    field :destroy_like, mutation: Mutations::UserActivity::DestroyLike
    field :create_recording_listen, mutation: Mutations::UserActivity::CreateRecordingListen
    field :destroy_recording_listen, mutation: Mutations::UserActivity::DestroyRecordingListen
  end
end
