module Resolvers
  class TimePeriod < BaseResolver
    type Types::TimePeriodType, null: false

    argument :id, ID, required: true, description: "ID of the period."

    def resolve(id:)
      ::TimePeriod.find(id)
    end
  end
end
