module Types
  class RecordingAggregationsType < Types::BaseObject
    field :genre, [AggregateType], null: false
    field :orchestra_periods, [AggregateType], null: false
    field :singers, [AggregateType], null: false
    field :time_period, [AggregateType], null: false
  end
end
