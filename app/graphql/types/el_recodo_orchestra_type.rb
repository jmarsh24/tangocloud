# frozen_string_literal: true

module Types
  class ElRecodoOrchestraType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :path, String, null: false

    has_many :songs, type: Types::ElRecodoSongType
    has_many :person_roles, type: Types::ElRecodoPersonRoleType
    has_many :people, type: Types::ElRecodoPersonType
  end
end
