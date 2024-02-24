module Types
  class EventType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Types::UuidType, null: false
    field :action, String, null: false
    field :user_agent, String
    field :ip_address, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :user
  end
end
