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
    field :album, AlbumType, null: true
    field :remaster_agent, RemasterAgentType, null: true
    field :recording, RecordingType, null: false
    field :audio_file, AudioFileType, null: false

    has_many :audio_variants
  end
end
