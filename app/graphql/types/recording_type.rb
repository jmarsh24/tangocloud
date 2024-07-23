module Types
  class RecordingTypeEnum < Types::BaseEnum
    value "studio"
    value "live"
  end

  class RecordingType < Types::BaseObject
    field :id, ID, null: false
    field :recorded_date, GraphQL::Types::ISO8601Date, null: true
    field :recording_type, Types::RecordingTypeEnum, null: false
    field :slug, String, null: false
    field :playbacks_count, Integer, null: false

    belongs_to :el_recodo_song
    belongs_to :orchestra
    belongs_to :composition
    belongs_to :record_label
    belongs_to :genre
    belongs_to :time_period

    has_many :recording_singers
    has_many :singers
    has_many :playbacks
    has_many :likes
    has_many :taggings
    has_many :tags
    has_many :shares
    has_many :playlist_items
    has_many :digital_remasters
    has_many :audio_variants
    has_many :lyrics
    has_many :tanda_recordings
    has_many :tandas
    has_many :waveforms

    def year
      object.recorded_date&.year
    end
  end
end
