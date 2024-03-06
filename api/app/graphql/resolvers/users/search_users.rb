module Resolvers::Users
  class SearchUsers < Resolvers::BaseResolver
    type Types::UserType.connection_type, null: false

    argument :query, String, required: true, description: "Search query."

    def resolve(query:)
      User.search_users(query).results
    end
  end
end
