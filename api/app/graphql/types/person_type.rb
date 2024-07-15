module Types
  class PersonType < Types::BaseObject
    field :id, ID, null: true

    field :bio, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true
    field :email, String, null: true
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :name, String, null: true
    field :slug, String, null: true
    field :sort_name, String, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true

    has_many :compositions
    has_many :orchestra_roles
    has_many :orchestra_positions
    has_many :orchestra_periods
  end
end
