# frozen_string_literal: true

module Types
  class CompositionLyricType < Types::BaseObject
    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :composition
    belongs_to :lyric
  end
end
