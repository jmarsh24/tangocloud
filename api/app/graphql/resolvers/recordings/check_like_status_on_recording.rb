module Resolvers::Recordings
  class CheckLikeStatusOnRecording < Resolvers::BaseResolver
    type Boolean, null: false

    argument :recording_id, ID, required: true, description: "ID of the recording."

    def resolve(recording_id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Like.exists?(user_id: context[:current_user].id, likeable_id: recording_id, likeable_type: "Recording")
    end
  end
end
