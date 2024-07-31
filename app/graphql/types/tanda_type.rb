# frozen_string_literal: true

module Types
  class TandaType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :subtitle, String
    field :description, String
    field :public, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :user
    has_many :tanda_recordings
    has_many :recordings
    has_many :playlist_items
    has_many :playlists
    has_many :shares
    has_many :likes
  end
end
