module Types
  class RecordingAggregationInputType < Types::BaseInputObject
    description "Input for defining aggregation options"

    argument :field, Types::RecordingAggregationFieldEnumType, required: false
  end
end
