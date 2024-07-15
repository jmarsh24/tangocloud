module Types
  class RecordingSearchResultsType < Types::BaseObject
    field :recordings, Types::RecordingType.connection_type, null: false
    field :aggregations, Types::RecordingAggregationsType, null: false
  end
end
