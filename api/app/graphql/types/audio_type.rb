module Types
  class AudioType < Types::BaseObject
    field :id, ID, null: true
    field :duration, Integer, null: true
    field :format, String, null: true
    field :codec, String, null: true
    field :bit_rate, Integer, null: true
    field :sample_rate, Integer, null: true
    field :channels, Integer, null: true
    field :length, Integer, null: true
    field :metadata, GraphQL::Types::JSON, null: true
    field :audio_transfer_id, ID, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true
  end
end
