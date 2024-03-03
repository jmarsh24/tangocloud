module Resolvers::Recordings
  class FetchRecording < Resolvers::BaseResolver
    type Types::RecordingType, null: false

    argument :id, ID, required: true, description: "ID of the recording."

    def resolve(id:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Recording.find(id)
    end
  end
end
