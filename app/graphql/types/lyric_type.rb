module Types
  class LyricType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :id, ID, null: false
    field :text, String, null: false
    field :updated_at, GraphQL::Types::ISO8601Date, null: true

    belongs_to :composition
    belongs_to :language
  end
end
