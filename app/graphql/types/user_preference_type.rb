module Types
  class UserPreferenceType < BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :first_name, String, null: true
    field :id, ID, null: false
    field :last_name, String, null: true
    field :name, String, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :user
    has_one_attached :avatar
  end
end
