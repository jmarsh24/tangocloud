module Types
  class DigitalRemasterType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :duration, Integer, null: true
    field :id, ID, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true
    field :waveform, WaveformType, null: true

    belongs_to :album, null: true
    belongs_to :recording, null: true
    belongs_to :remaster_agent, null: true
    has_many :audio_variants
    has_many :playlist_items
    has_one :audio_file
  end
end
