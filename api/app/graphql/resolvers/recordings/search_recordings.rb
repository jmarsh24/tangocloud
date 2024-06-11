module Resolvers::Recordings
  class SearchRecordings < Resolvers::BaseSearchResolver
    type Types::RecordingType.connection_type, null: false
    scope { Recording.all }
    create_connection_for(Recording)
    add_filter_by_datetime_for(Recording)
    add_order_by_for(Recording)
    add_search_for(Recording,
      fields: ["title^2", "orchestra_name", "singer_names", "genre", "year"],
    )

    def resolve(**args)
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      super
    end
  end
end
