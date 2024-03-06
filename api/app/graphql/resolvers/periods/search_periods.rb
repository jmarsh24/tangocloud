module Resolvers::Periods
  class SearchPeriods < Resolvers::BaseResolver
    type Types::PeriodType.connection_type, null: false

    argument :query, String, required: false, description: "Search query."

    def resolve(query: "*")
      Period.search_periods(query).results
    end
  end
end
