# frozen_string_literal: true

module Types
  class AudioType < Types::BaseObject
    field :id, ID, null: false
    field :bit_rate, Integer, null: true
    field :sample_rate, Integer, null: true
    field :channels, Integer, null: true
    field :bit_depth, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :bit_rate_mode, String, null: true
    field :codec, String, null: true
    field :length, Float, null: true
    field :encoder, String, null: true
    field :metadata, GraphQL::Types::JSON, null: false

    field :audio_transfers, [Types::AudioTransferType], null: false
    field :transfer_agents, [Types::TransferAgentType], null: false

  end
end
