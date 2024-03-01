module Types
  class PlaylistAudioTransferType < Types::BaseObject
    field :id, ID, null: false
    field :position, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :audio_transfer
    belongs_to :playlist
  end
end
