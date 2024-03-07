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
    field :system, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :image_url, String, null: true

    def image_url
      dataloader.with(Sources::Preload, image_attachment: :blob).load(object)
      object.image&.url
    end

    field :playlist_items, [PlaylistItemType], null: true

    def playlist_items
      dataloader.with(Sources::Preload, :playlist_items).load(object)
      object.playlist_items
    end

    field :recordings, [RecordingType], null: false

    def recordings
      dataloader.with(Sources::Preload, playlist_items: :recording).load(object)
      object.recordings
    end

    field :audio_variants, [AudioVariantType], null: false

    def audio_variants
      dataloader.with(Sources::Preload, playlist_items: {recording: {audio_transfers: :audio_variants}}).load(object)
      object.audio_variants
    end

    belongs_to :user
  end
end
