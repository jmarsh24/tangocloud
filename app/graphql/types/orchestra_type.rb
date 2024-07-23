module Types
  class OrchestraType < Types::BaseObject
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true
    field :first_name, String, null: true
    field :id, ID, null: true
    field :last_name, String, null: true
    field :name, String, null: true
    field :rank, Integer, null: true
    field :slug, String, null: true
    field :sort_name, String, null: true

    has_many :time_periods
    has_many :compositions
    has_many :orchestra_roles
    has_many :recordings
    has_one_attached :photo
  end
end
