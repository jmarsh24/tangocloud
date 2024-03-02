module Types
  class ListenType < Types::BaseObject
    field :id, ID, null: false
    field :recording, Types::RecordingType, null: false
    field :user, Types::UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
