# frozen_string_literal: true

module Types
  class ElRecodoSongType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :date, GraphQL::Types::ISO8601Date, null: false
    field :disk, String
    field :duration, Integer
    field :ert_number, Integer, null: false
    field :formatted_title, String
    field :id, ID, null: false
    field :instrumental, Boolean, null: false
    field :label, String
    field :lyrics, String
    field :lyrics_year, Integer
    field :matrix, String
    field :page_updated_at, GraphQL::Types::ISO8601DateTime
    field :speed, Integer
    field :style, String
    field :synced_at, GraphQL::Types::ISO8601DateTime, null: false
    field :title, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :orchestra, type: Types::ElRecodoOrchestraType
    has_many :person_roles, type: Types::ElRecodoPersonRoleType
    has_many :people, type: Types::ElRecodoPersonType
  end
end
