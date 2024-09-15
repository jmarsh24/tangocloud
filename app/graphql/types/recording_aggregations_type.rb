module Types
  class RecordingAggregationsType < Types::BaseObject
    field :orchestra, [AggregateType], null: true
    field :genre, [AggregateType], null: true
    field :orchestra_periods, [AggregateType], null: true
    field :singers, [AggregateType], null: true
    field :time_period, [AggregateType], null: true
    field :year, [AggregateType], null: true
  end
end
