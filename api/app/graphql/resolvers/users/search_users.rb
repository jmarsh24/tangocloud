module Resolvers::Users
  class SearchUsers < Resolvers::BaseResolver
    type Types::UserType.connection_type, null: false

    argument :query, String, required: true, description: "Search query."

    def resolve(query: "*")
      User.search(query, fields: [:username, :email, :first_name, :last_name], match: :word_start).results
    end
  end
end
