module Resolvers
  class Orchestras < BaseResolver
    type Types::OrchestraType.connection_type, null: false

    argument :query, String, required: false

    def resolve(query: "*")
      ::Orchestra.search(query,
        fields: ["name^5"],
        match: :word_start,
        misspellings: {below: 5}).results
    end
  end
end
