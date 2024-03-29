# frozen_string_literal: true

module Types
  class PlaylistItemType < Types::BaseObject
    field :id, ID, null: false
    field :playable_type, String, null: false
    field :position, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :playlist
    belongs_to :playable, type: Types::PlayableType, null: false, association: :playable
  end
end
