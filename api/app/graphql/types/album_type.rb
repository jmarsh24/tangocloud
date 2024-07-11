module Types
  class AlbumType < Types::BaseObject
    include Rails.application.routes.url_helpers

    field :id, ID, null: true
    field :title, String, null: true
    field :description, String, null: true
    field :release_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: true
    field :external_id, String, null: true
    field :album_type, String, null: true

    has_many :digital_remaster
    has_one_attached :album_art
  end
end
