# frozen_string_literal: true

module Types
  class AlbumType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :release_date, GraphQL::Types::ISO8601Date, null: true
    field :recordings_count, Integer, null: false
    field :slug, String, null: false
    field :external_id, String, null: true
    field :transfer_agent_id, ID, null: true
    field :type, String, null: false
    field :recordings, [Types::RecordingType], null: true
    field :orchestras, [Types::OrchestraType], null: true
    field :singers, [Types::SingerType], null: true
    field :composers, [Types::ComposerType], null: true
    field :lyricists, [Types::LyricistType], null: true
    field :compositions, [Types::CompositionType], null: true
    field :audio, [Types::AudioType], null: true
    field :audio_transfers, [Types::AudioTransferType], null: true
  end
end
