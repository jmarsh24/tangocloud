module Resolvers::Users
  class UserProfile < Resolvers::BaseResolver
    type Types::UserType, null: false

    def resolve
      context[:current_user]
    end
  end
end
