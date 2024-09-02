module Types
  class RecordingAggregationsType < Types::BaseObject
    field :genre, [AggregateType], null: true
    field :orchestra_periods, [AggregateType], null: true
    field :singers, [AggregateType], null: true
    field :time_period, [AggregateType], null: true
  end
end
