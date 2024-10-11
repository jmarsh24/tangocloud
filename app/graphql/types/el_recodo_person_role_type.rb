# frozen_string_literal: true

module Types
  class ElRecodoPersonRoleType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :id, ID, null: false
    field :role, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :person, type: Types::ElRecodoPersonType
    belongs_to :song, type: Types::ElRecodoSongType
  end
end
