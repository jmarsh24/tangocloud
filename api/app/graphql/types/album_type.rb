module Types
  class AlbumType < Types::BaseObject
    field :id, ID, null: true
    field :title, String
    field :description, String, null: true
    field :release_date, GraphQL::Types::ISO8601Date, null: true
    field :external_id, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true

    has_many :digital_remasters
    has_one_attached :album_art
  end
end
