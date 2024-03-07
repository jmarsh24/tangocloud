# frozen_string_literal: true

module Types
  class PlaylistItemType < Types::BaseObject
    field :id, ID, null: false
    field :playlist_id, ID, null: false
    field :playable_type, String, null: false
    field :playable_id, ID, null: false
    field :position, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :playable, Types::PlayableType, null: false

    def playable
      dataloader.with(Sources::Preload, :playable).load(object)
      object.playable
    end

    belongs_to :playlist
  end
end
