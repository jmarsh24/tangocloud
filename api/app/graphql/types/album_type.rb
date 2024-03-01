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
    field :album_art, Types::ImageType, null: true
    def album_art
      object.album_art.presence
    end
    has_many :audio_transfers
  end
end
