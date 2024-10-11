module Types
  class RecordingTypeEnum < Types::BaseEnum
    value "studio"
    value "live"
  end

  class RecordingType < Types::BaseObject
    field :id, ID, null: false
    field :liked_by_current_user, Boolean, null: true
    field :playbacks_count, Integer, null: false
    field :recorded_date, GraphQL::Types::ISO8601Date, null: true
    field :recording_type, Types::RecordingTypeEnum, null: false
    field :slug, String, null: false
    field :year, Integer, null: true

    belongs_to :record_label, null: true
    belongs_to :time_period, null: true
    belongs_to :genre, null: true
    belongs_to :composition, null: true
    belongs_to :orchestra, null: true, type: Types::OrchestraType
    belongs_to :el_recodo_song, null: true, type: Types::ElRecodoSongType
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
    has_many :tandas
    has_many :waveforms

    def year
      object.recorded_date&.year
    end

    def liked_by_current_user
      dataloader.with(Sources::LikeSource, user: current_user, likeable_type: "Recording").load(object.id)
    end
  end
end
