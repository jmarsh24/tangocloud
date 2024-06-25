module Resolvers
  class Periods < BaseResolver
    type Types::PeriodType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      ::Period.search(query,
        fields: ["name^5"],
        match: :word_start,
        misspellings: {below: 5}).results
    end
  end
end
