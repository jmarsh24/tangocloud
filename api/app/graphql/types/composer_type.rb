# frozen_string_literal: true

module Types
  class ComposerType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true
    field :recordings, [Types::RecordingType], null: true
    field :compositions, [Types::CompositionType], null: true
    field :orchestras, [Types::OrchestraType], null: true
    field :singers, [Types::SingerType], null: true
    field :lyricists, [Types::LyricistType], null: true
    field :audio, [Types::AudioType], null: true
    field :audio_transfers, [Types::AudioTransferType], null: true
  end
end
