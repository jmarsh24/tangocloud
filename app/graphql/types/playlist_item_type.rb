# frozen_string_literal: true

module Types
  class PlaylistItemType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :id, ID, null: false
    field :item_type, String, null: false
    field :position, Integer, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :playlist, Types::PlaylistType, null: false
    field :item, Types::ItemType, null: false
  end
end
