module Authenticating
  extend ActiveSupport::Concern

  included do
    def current_user
      context[:current_user]
    end

    def check_authentication!
      return if context[:current_user]

      raise GraphQL::ExecutionError, "You need to authenticate to perform this action"
    end
  end
end
