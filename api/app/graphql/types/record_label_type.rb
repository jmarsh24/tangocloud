module Types
  class RecordLabelType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :description, String, null: true
    field :founded_date, GraphQL::Types::ISO8601Date, null: true
    field :id, ID, null: true
    field :name, String, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true

    has_many :recordings
  end
end
