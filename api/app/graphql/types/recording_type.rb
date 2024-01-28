# frozen_string_literal: true

class Types::RecordingType < Types::BaseObject
  field :id, ID, null: false
  field :title, String, null: false
  field :bpm, Integer, null: true
  field :release_date, GraphQL::Types::ISO8601Date, null: true
  field :recorded_date, GraphQL::Types::ISO8601Date, null: true
  field :el_recodo_song_id, ID, null: true
  field :orchestra_id, ID, null: true
  field :singer_id, ID, null: true
  field :composition_id, ID, null: true
  field :label_id, ID, null: true
  field :genre_id, ID, null: true
  field :period_id, ID, null: true
  field :type, String, null: false
  field :el_recodo_song, Types::ElRecodoSongType, null: true
  field :orchestra, Types::OrchestraType, null: true
  field :singer, Types::SingerType, null: true
  field :composition, Types::CompositionType, null: true
  field :label, Types::LabelType, null: true
  field :genre, Types::GenreType, null: true
  field :period, Types::PeriodType, null: true
  field :audio, [Types::AudioType], null: true
  field :audio_transfers, [Types::AudioTransferType], null: true
end
