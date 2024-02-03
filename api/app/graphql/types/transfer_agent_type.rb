# frozen_string_literal: true

module Types
  class TransferAgentType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :url, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
