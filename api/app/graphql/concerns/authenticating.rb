module Authenticating
  extend ActiveSupport::Concern

  included do
    def current_user
      context[:current_user]
    end

    def current_user!
      current_user || raise(GraphQL::ExecutionError, "unauthenticated")
    end
  end
end
