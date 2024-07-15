module Mutations::Recordings
  class AddLikeToRecording < Mutations::BaseMutation
    field :errors, [String], null: false
    field :like, Types::LikeType, null: true
    field :success, Boolean, null: false

    argument :recording_id, ID, required: true

    def resolve(recording_id:)
      check_authentication!

      like = Like.new(likeable_type: "Recording", likeable_id: recording_id, user: current_user)
      if like.save
        {like:, success: true, errors: []}
      else
        {like: nil, success: false, errors: like.errors.full_messages}
      end
    end
  end
end
