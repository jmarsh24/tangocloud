module Types
  class OrchestraPeriodType < Types::BaseObject
    field :id, ID, null: false

    field :name, String, null: true
    field :description, String, null: true
    field :start_date, GraphQL::Types::ISO8601Date, null: true
    field :end_date, GraphQL::Types::ISO8601Date, null: true

    belongs_to :orchestra, type: Types::OrchestraType
  end
end
