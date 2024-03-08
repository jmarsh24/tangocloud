module Resolvers::Recordings
  class SearchRecordings < Resolvers::BaseResolver
    type Types::RecordingType.connection_type, null: false

    argument :query, String, required: false, description: "Query to search for."

    def resolve(query:)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Recording.search_recordings(query || "*").results
    end
  end
end
