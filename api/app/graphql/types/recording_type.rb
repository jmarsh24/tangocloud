module Types
  class RecordingType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :bpm, Integer, null: true
    field :release_date, GraphQL::Types::ISO8601Date, null: true
    field :recorded_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: false
    field :recording_type, String, null: false
    field :el_recodo_song, Types::ElRecodoSongType, null: true
    field :orchestra, Types::OrchestraType, null: true
    field :composition, Types::CompositionType, null: true
    field :record_label, Types::RecordLabelType, null: true
    field :genre, Types::GenreType, null: true
    field :period, Types::PeriodType, null: true
    field :lyricist, Types::LyricistType, null: true
    field :composer, Types::ComposerType, null: true
    field :album_art_url, String, null: true
    field :audio_transfer, Types::AudioTransferType, null: false
    field :singers, [Types::SingerType], null: true
    field :audios, [Types::AudioType], null: true
  end
end
