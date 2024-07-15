module Types
  class LanguageType < Types::BaseObject
    field :code, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :id, ID, null: false
    field :name, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    has_many :lyrics
  end
end
