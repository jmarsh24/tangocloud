module Types
  class RecordingSingerType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :id, ID, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :soloist, Boolean, null: false
    field :recording, Types::RecordingType, null: false
    field :person, Types::PersonType, null: false
  end
end
