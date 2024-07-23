module Types
  class RecordingSearchResultsType < Types::BaseObject
    field :aggregations, Types::RecordingAggregationsType, null: false
    field :recordings, Types::RecordingType.connection_type, null: false
  end
end
