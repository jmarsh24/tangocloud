module Types
  class AlbumType < Types::BaseObject
    field :id, ID, null: true
    field :title, String, null: true
    field :description, String, null: true
    field :release_date, GraphQL::Types::ISO8601Date, null: true
    field :audio_transfers_count, Integer, null: true
    field :slug, String, null: true
    field :external_id, String, null: true
    field :album_type, String, null: true

    field :album_art_url, String, null: true

    def album_art_url
      dataloader.with(Sources::Preload, album_art_attachment: :blob).load(object)
      object.album_art.presence
    end

    field :audio_transfers, [AudioTransferType], null: false

    def audio_transfers
      dataloader.with(Sources::Preload, :audio_transfers).load(object)
    end
  end
end
