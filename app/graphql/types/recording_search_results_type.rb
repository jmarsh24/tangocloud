module Types
  class RecordingSearchResultsType < Types::BaseObject
    field :aggregations, Types::RecordingAggregationsType, null: true
    field :recordings, Types::RecordingType.connection_type, null: false
  end
end
