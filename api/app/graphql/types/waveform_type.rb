# frozen_string_literal: true

module Types
  class WaveformType < Types::BaseObject
    field :id, ID, null: false
    field :audio_transfer_id, Types::UuidType, null: false
    field :version, Integer, null: false
    field :channels, Integer, null: false
    field :sample_rate, Integer, null: false
    field :samples_per_pixel, Integer, null: false
    field :bits, Integer, null: false
    field :length, Integer, null: false
    field :data, Float
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
