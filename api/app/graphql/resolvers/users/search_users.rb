module Resolvers::Users
  class SearchUsers < Resolvers::BaseResolver
    type [Types::UserType], null: false

    argument :query, String, required: true, description: "Search query."

    def resolve(query:)
      User.search_users(query)
    end
  end
end
