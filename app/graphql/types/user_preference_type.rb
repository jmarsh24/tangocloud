module Types
  class UserPreferenceType < BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :name, String, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :user, Types::UserType, null: false

    has_one_attached :avatar
  end
end
