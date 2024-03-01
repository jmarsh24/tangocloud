module Types
  class RecordingType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :bpm, Integer, null: true
    field :release_date, GraphQL::Types::ISO8601Date, null: true
    field :recorded_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: false
    field :recording_type, String, null: false

    field :audio_transfers, [AudioTransferType], null: false

    def audio_transfers
      dataloader.with(Sources::Preload, :audio_transfers).load(object)
      object.audio_transfers
    end

    field :audio_variants, [AudioVariantType], null: false

    def audio_variants
      dataloader.with(Sources::Preload, audio_transfers: :audio_variants).load(object)
      object.audio_variants
    end

    field :singers, [SingerType], null: false

    def singers
      dataloader.with(Sources::Preload, :singers).load(object)
      object.singers
    end

    belongs_to :el_recodo_song
    belongs_to :orchestra
    belongs_to :composition
    belongs_to :record_label
    belongs_to :genre
    belongs_to :period
    belongs_to :lyricist
    belongs_to :composer
  end
end
