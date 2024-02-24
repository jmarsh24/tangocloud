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
    field :audio_variants, [Types::AudioVariantType], null: false
    field :waveform, Types::WaveformType, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true

    def audio_file_url
      if object.audio_file.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.audio_file)
      end
    end
  end
end
