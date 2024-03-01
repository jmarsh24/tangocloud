module Types
  class RecordingType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :bpm, Integer, null: true
    field :release_date, GraphQL::Types::ISO8601Date, null: true
    field :recorded_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: false
    field :recording_type, String, null: false

    belongs_to :el_recodo_song
    belongs_to :orchestra
    belongs_to :composition
    belongs_to :record_label
    belongs_to :genre
    belongs_to :period
    belongs_to :lyricist
    belongs_to :composer
    has_many :audio_transfers
    has_many :audio_variants
    has_many :singers
    has_many :waveforms
  end
end
