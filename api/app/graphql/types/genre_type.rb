module Types
  class GenreType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: false
    field :slug, String, null: true
    field :rank, Integer, null: true
    field :sort_name, String, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true
  end
end
