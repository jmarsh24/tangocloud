module Types
  class PlaylistItemType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :id, ID, null: false
    field :item_type, String, null: false
    field :position, Integer, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :playlistable, type: Types::PlaylistableUnionType, null: false
    belongs_to :item, type: Types::ItemUnionType, null: false
  end
end
