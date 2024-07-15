module Types
  class RecordingAggregationsType < Types::BaseObject
    field :orchestra_periods, [AggregateType], null: false
    field :time_period, [AggregateType], null: false
    field :genre, [AggregateType], null: false
    field :singers, [AggregateType], null: false
  end
end
