module Types
  class AudioTransferType < Types::BaseObject
    field :id, ID, null: true
    field :position, Integer, null: true
    field :filename, String, null: true
    field :waveform, WaveformType, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true

    has_one_attached :audio

    belongs_to :album, null: true
    belongs_to :recording, null: true
    belongs_to :transfer_agent, null: true
    has_many :audio_variants
    has_many :playlist_items
  end
end
