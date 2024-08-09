# frozen_string_literal: true

module Types
  class ElRecodoPersonType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :birth_date, GraphQL::Types::ISO8601Date
    field :death_date, GraphQL::Types::ISO8601Date
    field :real_name, String
    field :nicknames, String
    field :place_of_birth, String
    field :path, String
    field :synced_at, GraphQL::Types::ISO8601DateTime, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    has_many :person_roles, type: Types::ElRecodoPersonRoleType
    has_many :songs, type: Types::ElRecodoSongType
  end
end
