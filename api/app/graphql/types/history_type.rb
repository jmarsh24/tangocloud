# frozen_string_literal: true

module Types
  class HistoryType < Types::BaseObject
    field :id, ID, null: false
    field :recording, Types::RecordingType, null: false
    field :user, Types::UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
