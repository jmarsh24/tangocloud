# frozen_string_literal: true

module Types
  class CompositionLyricType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :id, ID, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :composition, Types::CompositionType, null: false
    field :lyric, Types::LyricType, null: false
  end
end
