module Types
  class GenreType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    has_many :recordings
  end
end
