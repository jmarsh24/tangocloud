module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Users::Login
    field :register, mutation: Mutations::Users::Register

    field :like_recording, mutation: Mutations::UserActivity::LikeRecording
    field :unlike_recording, mutation: Mutations::UserActivity::UnlikeRecording
    field :create_recording_listen, mutation: Mutations::UserActivity::CreateRecordingListen
    field :destroy_recording_listen, mutation: Mutations::UserActivity::DestroyRecordingListen
  end
end
