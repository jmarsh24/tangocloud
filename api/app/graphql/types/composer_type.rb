module Types
  class ComposerType < Types::BaseObject
    include Rails.application.routes.url_helpers

    field :id, ID, null: true
    field :name, String, null: false
    field :rank, Integer, null: true
    field :sort_name, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: true
    field :compositions_count, Integer, null: true

    field :photo_url, null: true, extensions: [ImageUrlField]

    has_many :compositions
  end
end
