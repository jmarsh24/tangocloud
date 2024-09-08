module Types
  class PersonType < Types::BaseObject
    field :id, ID, null: false

    field :bio, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true
    field :name, String, null: true
    field :slug, String, null: true
    field :sort_name, String, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true

    has_many :composition_roles
    has_many :compositions
    has_many :orchestra_roles
    has_many :orchestras
    has_many :recording_singers
    has_many :recordings

    has_one_attached :image
  end
end
