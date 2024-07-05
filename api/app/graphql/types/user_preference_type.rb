module Types
  class UserPreferenceType < BaseObject
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :name, String, null: true
    field :user_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
