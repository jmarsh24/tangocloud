module Types
  class RecordingAggregationFieldEnumType < Types::BaseEnum
    description "Fields allowed for aggregations"

    value "genre", "Aggregate by genre", value: "genre"
    value "orchestraPeriods", "Aggregate by orchestra period", value: "orchestraPeriods"
    value "timePeriod", "Aggregate by time period", value: "timePeriod"
    value "year", "Aggregate by year", value: "year"
    value "singers", "Aggregate by singer", value: "singers"
    value "orchestra", "Aggregate by orchestra", value: "orchestra"
  end
end
