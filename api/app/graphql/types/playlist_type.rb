module Types
  class PlaylistType < Types::BaseObject
    include Rails.application.routes.url_helpers

    field :id, ID, null: false
    field :title, String, null: false
    field :description, String
    field :public, Boolean, null: false
    field :songs_count, Integer, null: false
    field :likes_count, Integer, null: false
    field :listens_count, Integer, null: false
    field :shares_count, Integer, null: false
    field :followers_count, Integer, null: false
    field :system, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :image_url, String, null: true

    def image_url
      dataloader.with(Sources::Preload, image_attachment: :blob).load(object)
      cdn_image_url(object.image.variant(:medium))
    end

    belongs_to :user
    has_many :playlist_items
    has_many :recordings
    has_many :audio_variants
  end
end
