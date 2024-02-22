# frozen_string_literal: true

module Types
  class PlaylistAudioTransferType < Types::BaseObject
    field :id, ID, null: false
    field :playlist_id, Types::UuidType, null: false
    field :audio_transfer_id, Types::UuidType, null: false
    field :position, Integer, null: false
    field :audio_transfer, Types::AudioTransferType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
