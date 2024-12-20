module Resolvers
  class CurrentUser < BaseResolver
    type Types::UserType, null: false

    def resolve
      authenticate_user!

      context[:current_user]
    end
  end
end
