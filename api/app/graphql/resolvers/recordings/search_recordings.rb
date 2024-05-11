module Resolvers::Recordings
  class SearchRecordings < Resolvers::BaseResolver
    type Types::RecordingType.connection_type, null: false

    argument :query, String, required: false, description: "Query to search for."
    argument :sort_by, String, required: false, description: "Field to sort by."
    argument :order, String, required: false, description: "Sort order, can be 'asc' or 'desc'."

    def resolve(query: nil, sort_by: nil, order: nil)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      Recording.search_recordings(query, sort_by:, order:)
    end
  end
end
