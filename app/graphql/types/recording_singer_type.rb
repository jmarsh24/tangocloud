module Types
  class RecordingSingerType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :id, ID, null: false
    field :soloist, Boolean, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :recording
    belongs_to :person, type: Types::PersonType
  end
end
