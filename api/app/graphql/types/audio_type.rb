# frozen_string_literal: true

module Types
  class AudioType < Types::BaseObject
    field :id, ID, null: false
    field :duration, Integer, null: false
    field :format, String, null: false
    field :codec, String, null: false
    field :bit_rate, Integer
    field :sample_rate, Integer
    field :channels, Integer
    field :length, Integer, null: false
    field :metadata, GraphQL::Types::JSON, null: false
    field :audio_transfer_id, Types::UuidType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
