module Types
  class LyricType < Types::BaseObject
    field :content, String, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :id, ID, null: true
    field :locale, String, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true

    belongs_to :composition
  end
end
