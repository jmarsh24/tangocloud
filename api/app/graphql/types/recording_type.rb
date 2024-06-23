module Types
  class RecordingType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :bpm, Integer, null: true
    field :release_date, GraphQL::Types::ISO8601Date, null: true
    field :recorded_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: false
    field :recording_type, String, null: false
    field :year, Integer, null: true

    def year
      object.recorded_date&.year
    end

    belongs_to :el_recodo_song, null: true
    belongs_to :orchestra
    belongs_to :composition, null: true
    belongs_to :record_label, null: true
    belongs_to :genre
    belongs_to :period, null: true
    belongs_to :lyricist, null: true
    belongs_to :composer, null: true

    has_many :playbacks
    has_many :likes
    has_many :audio_transfers
    has_many :audio_variants
    has_many :singers
  end
end
