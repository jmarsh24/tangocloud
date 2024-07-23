module Types
  class EventType < Types::BaseObject
    field :action, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :id, ID, null: false
    field :ip_address, String
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :user_agent, String

    belongs_to :user
  end
end
