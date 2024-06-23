module Resolvers::Periods
  class SearchPeriods < Resolvers::BaseResolver
    type Types::PeriodType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      Period.search(query,
        fields: ["name^5"],
        match: :word_middle,
        misspellings: {below: 5}).results
    end
  end
end
