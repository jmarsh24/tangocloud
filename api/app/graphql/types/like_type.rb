module Types
  class LikeType < Types::BaseObject
    field :id, ID, null: false
    field :likeable_type, String, null: false
    field :likeable_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :user
  end
end
