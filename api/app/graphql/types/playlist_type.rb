module Types
  class PlaylistType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String
    field :public, Boolean, null: false
    field :songs_count, Integer, null: false
    field :likes_count, Integer, null: false
    field :listens_count, Integer, null: false
    field :shares_count, Integer, null: false
    field :followers_count, Integer, null: false
    field :user_id, Types::UuidType, null: false
    field :image_url, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def image_url
      if object.image.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.image)
      end
    end

    belongs_to :user
    has_many :playlist_audio_transfers
    has_many :audio_transfers
  end
end
