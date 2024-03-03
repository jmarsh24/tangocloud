module Resolvers::Users
  class WhoAmI < Resolvers::BaseResolver
    type Types::UserType, null: false

    def resolve
      context[:current_user]
    end
  end
end
