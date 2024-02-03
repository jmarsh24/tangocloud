# frozen_string_literal: true

module Types
  class TandaRecordingType < Types::BaseObject
    field :id, ID, null: false
    field :position, Integer, null: false
    field :tanda_id, Types::UuidType, null: false
    field :recording_id, Types::UuidType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
