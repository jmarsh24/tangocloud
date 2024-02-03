module Types
  class RecordingType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :bpm, Integer
    field :release_date, GraphQL::Types::ISO8601Date
    field :recorded_date, GraphQL::Types::ISO8601Date
    field :slug, String, null: false
    field :recording_type, String, null: false
    field :el_recodo_song, Types::ElRecodoSongType, null: true
    field :orchestra, Types::OrchestraType, null: true
    field :singer, Types::SingerType, null: true
    field :composition, Types::CompositionType, null: true
    field :record_label, Types::RecordLabelType, null: true
    field :genre, Types::GenreType, null: true
    field :period, Types::PeriodType, null: true
  end
end
