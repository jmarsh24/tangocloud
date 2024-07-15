module Types
  class AlbumType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :description, String, null: true
    field :external_id, String, null: true
    field :id, ID, null: true
    field :release_date, GraphQL::Types::ISO8601Date, null: true
    field :title, String
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true

    has_many :digital_remasters
    has_one_attached :album_art
  end
end
