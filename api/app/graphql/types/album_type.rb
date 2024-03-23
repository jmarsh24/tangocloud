module Types
  class AlbumType < Types::BaseObject
    include Rails.application.routes.url_helpers

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
      cdn_image_url(object.album_art.variant(:large)) if object.album_art.attached?
    end

    field :audio_transfers, [AudioTransferType], null: false

    def audio_transfers
      dataloader.with(Sources::Preload, :audio_transfers).load(object)
      object.audio_transfers
    end
  end
end
