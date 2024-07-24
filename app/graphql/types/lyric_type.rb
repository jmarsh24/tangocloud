module Types
  class LyricType < Types::BaseObject
    field :id, ID, null: true
    field :text, String, null: false
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true
    field :composition, Types::CompositionType, null: false
    field :language, Types::LanguageType, null: false
  end
end
