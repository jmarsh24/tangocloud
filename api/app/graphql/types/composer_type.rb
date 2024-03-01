module Types
  class ComposerType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: false
    field :rank, Integer, null: true
    field :sort_name, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: true
    field :compositions_count, Integer, null: true

    has_many :compositions
    has_many :recordings
  end
end
