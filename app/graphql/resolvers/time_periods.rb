module Resolvers
  class TimePeriods < BaseResolver
    type Types::TimePeriodType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      check_authentication!

      ::TimePeriod.search(query,
        fields: ["name^5"],
        match: :word_start,
        misspellings: {below: 5}).results
    end
  end
end
