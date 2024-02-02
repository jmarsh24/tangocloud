module Types
  class RecordLabel < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :description, String, null: true
    field :founded_date, GraphQL::Types::ISO8601Date, null: true
  end
end
