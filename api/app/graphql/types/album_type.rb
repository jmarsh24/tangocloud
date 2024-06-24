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
    field :album_art, AttachedType, null: true

    def album_art
      dataloader
        .with(GraphQL::Sources::ActiveStorageHasOneAttached, :album_art)
        .load(object)
    end

    has_many :audio_transfers
  end
end
