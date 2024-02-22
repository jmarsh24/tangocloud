module Types
  class AudioTransferType < Types::BaseObject
    field :id, ID, null: true
    field :external_id, String, null: true
    field :position, Integer, null: true
    field :album_id, ID, null: true
    field :transfer_agent_id, ID, null: true
    field :recording_id, ID, null: true
    field :filename, String, null: true
    field :transfer_agent, Types::TransferAgentType, null: true
    field :album, Types::AlbumType, null: true
    field :playlist_audio_transfers, [Types::PlaylistAudioTransferType], null: true
    field :recording, Types::RecordingType, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true
  end
end
