module Types
  class AggregateType < Types::BaseObject
    field :key, String, null: false
    field :doc_count, Integer, null: false
  end
end
