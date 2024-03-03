module Resolvers
  class ListenHistoryResolver < Resolvers::BaseResolver
    type Types::ListenHistoryType, null: false

    def resolve
      raise GraphQL::ExecutionError, "Authentication is required to access this query." unless context[:current_user]

      context[:current_user].listen_history
    end
  end
end
