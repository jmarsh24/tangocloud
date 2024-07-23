module Types
  class DigitalRemasterType < Types::BaseObject
    field :id, ID, null: true
    field :duration, Integer, null: true
    field :bpm, Integer, null: true
    field :external_id, String, null: true
    field :replay_gain, Float, null: true
    field :peak_value, Float, null: true
    field :tango_cloud_id, String, null: false
    field :waveform, WaveformType, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true

    belongs_to :album, null: true
    belongs_to :remaster_agent, null: true
    belongs_to :recording, null: false
    belongs_to :audio_file
    has_many :audio_variants
    has_one :waveform
  end
end
