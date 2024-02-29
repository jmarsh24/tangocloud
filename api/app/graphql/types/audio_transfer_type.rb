module Types
  class AudioTransferType < Types::BaseObject
    field :id, ID, null: true
    field :external_id, String, null: true
    field :position, Integer, null: true
    field :album_id, ID, null: true
    field :transfer_agent_id, ID, null: true
    field :recording_id, ID, null: true
    field :filename, String, null: true
    field :recording, Types::RecordingType, null: true
    field :waveform, Types::WaveformType, null: true
    field :audio_file, Types::FileType, null: true
    def audio_file
      object.audio_file.presence
    end
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true


    has_many :audio_variants
    has_many :playlist_audio_transfers
    belongs_to :album
    belongs_to :recording
    belongs_to :transfer_agent
  end
end
