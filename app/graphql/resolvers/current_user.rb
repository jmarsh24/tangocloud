module Resolvers
  class CurrentUser < BaseResolver
    type Types::UserType, null: false

    def resolve
      check_authentication!

      context[:current_user]
    end
  end
end
