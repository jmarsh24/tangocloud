module Types
  class RecordingSingerType < Types::BaseObject
    field :id, ID, null: false
    field :recording_id, Types::UuidType, null: false
    field :singer_id, Types::UuidType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :recording
    belongs_to :singer
  end
end
