# frozen_string_literal: true

module Types
  class TandaType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :description, String
    field :id, ID, null: false
    field :public, Boolean, null: false
    field :subtitle, String
    field :title, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    has_many :tanda_recordings
    has_many :recordings
    has_many :playlist_items
    has_many :playlists
    has_many :shares
    has_many :likes
    belongs_to :user
  end
end
