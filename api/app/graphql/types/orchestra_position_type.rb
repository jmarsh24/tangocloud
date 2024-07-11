module Types
  class OrchestraPositionType < Types::BaseObject
    field :id, ID, null: true

    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true
  end
end
