module Resolvers::Periods
  class FetchPeriod < Resolvers::BaseResolver
    type Types::PeriodType, null: false

    argument :id, ID, required: true, description: "ID of the period."

    def resolve(id:)
      Period.find(id)
    end
  end
end
