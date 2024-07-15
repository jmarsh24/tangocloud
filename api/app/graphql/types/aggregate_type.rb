module Types
  class AggregateType < Types::BaseObject
    field :doc_count, Integer, null: false
    field :key, String, null: false
  end
end
