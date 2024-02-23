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
    field :user, Types::UserType, null: false
    field :playlist_audio_transfers, [Types::PlaylistAudioTransferType], null: false
    field :audio_transfers, [Types::AudioTransferType], null: false
    field :audio_variants, [Types::AudioVariantType], null: false
    field :recordings, [Types::RecordingType], null: false
    field :image_url, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def image_url
      if object.image.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.image)
      end
    end
  end
end
