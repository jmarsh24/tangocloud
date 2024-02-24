module Types
  class OrchestraType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :rank, Integer, null: true
    field :sort_name, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: true
    field :recordings_count, Integer, null: true

    has_many :compositions
    has_many :recordings
    has_many :singers
    has_many :lyricists
  end
end
