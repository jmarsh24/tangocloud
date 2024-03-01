# frozen_string_literal: true

module Types
  class TandaType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :public, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    has_many :tanda_recordings
  end
end
