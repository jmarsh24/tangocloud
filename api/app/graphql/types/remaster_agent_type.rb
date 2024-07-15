module Types
  class RemasterAgentType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :description, String
    field :id, ID, null: false
    field :name, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :url, String

    has_many :digital_remasters
  end
end
