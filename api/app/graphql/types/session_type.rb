module Types
  class SessionType < BaseObject
    field :access, String, null: true
    field :access_expires_at, GraphQL::Types::ISO8601DateTime, null: true
    field :refresh, String, null: true
    field :refresh_expires_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
