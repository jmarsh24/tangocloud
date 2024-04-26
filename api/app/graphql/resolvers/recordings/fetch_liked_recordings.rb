module Resolvers::Recordings
  class FetchLikedRecordings < Resolvers::BaseResolver
    type Types::RecordingType.connection_type, null: false

    def resolve
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Recording.joins(:likes).where(likes: {user_id: context[:current_user].id, likeable_type: "Recording"}).order("likes.created_at DESC")
    end
  end
end
