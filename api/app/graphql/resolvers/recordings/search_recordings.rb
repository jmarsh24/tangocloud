module Resolvers::Recordings
  class SearchRecordings < Resolvers::BaseSearchResolver
    type Types::RecordingType.connection_type, null: false

    argument :query, String, required: false, description: "Query to search for."

    def resolve(query: nil, sort_by: nil, order: nil)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      scope { Recording.all }
      add_search_for(Recording)
    end
  end
end
