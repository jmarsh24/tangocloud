module Types
  class OrchestraPositionType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :end_date, GraphQL::Types::ISO8601Date, null: true
    field :id, ID, null: false
    field :principal, Boolean, null: true
    field :start_date, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true

    belongs_to :orchestra
    belongs_to :orchestra_role
    belongs_to :person
  end
end
