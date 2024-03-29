module Types
  class AudioTransferType < Types::BaseObject
    field :id, ID, null: true
    field :position, Integer, null: true
    field :filename, String, null: true
    field :waveform, WaveformType, null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true

    field :audio_file_url, String, null: true

    def audio_file_url
      dataloader.with(Sources::Preload, audio_file_attachment: :blob).load(object)
      object.audio_file&.url
    end

    field :audio_variants, [AudioVariantType], null: false

    def audio_variants
      dataloader.with(Sources::Preload, :audio_variants).load(object)
      object.audio_variants
    end

    field :playlist_items, [PlaylistItemType], null: false

    def playlist_items
      dataloader.with(Sources::Preload, :playlist_items).load(object)
      object.playlist_items
    end

    belongs_to :album, null: true
    belongs_to :recording, null: true
    belongs_to :transfer_agent, null: true
  end
end
