module Types
  class PlaylistType < Types::BaseObject
    field :id, ID, null: true
    field :title, String, null: true
    field :description, String, null: true
    field :public, Boolean, null: true
    field :songs_count, Integer, null: true
    field :likes_count, Integer, null: true
    field :listens_count, Integer, null: true
    field :shares_count, Integer, null: true
    field :followers_count, Integer, null: true
    field :user, Types::UserType, null: true
    field :playlist_audio_transfers, [Types::PlaylistAudioTransferType], null: true
    field :created_at, GraphQL::Types::ISO8601Date, null: true
    field :updated_at, GraphQL::Types::ISO8601Date, null: true
  end
end
