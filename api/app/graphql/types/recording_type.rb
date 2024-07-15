module Types
  class RecordingTypeEnum < Types::BaseEnum
    value "studio"
    value "live"
  end

  class RecordingType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :bpm, Integer, null: true
    field :recorded_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: false
    field :recording_type, Types::RecordingTypeEnum, null: false
    field :year, Integer, null: true

    belongs_to :el_recodo_song
    belongs_to :orchestra
    belongs_to :composition
    belongs_to :record_label
    belongs_to :genre
    belongs_to :time_period

    has_many :playbacks
    has_many :likes
    has_many :digital_remasters
    has_many :audio_variants
    has_many :recording_singers

    def year
      object.recorded_date&.year
    end
  end
end
