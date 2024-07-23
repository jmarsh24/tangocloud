module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :username, String
    field :admin, Boolean, null: false
    field :provider, String
    field :uid, String
    field :email, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    has_one :user_preference
    has_many :likes, -> { most_recent }
    has_many :tandas
    has_many :playlists
    has_many :playlist_items
    has_many :taggings
    has_many :tags
    has_many :shares
    has_many :shared_recordings
    has_many :shared_playlists
    has_many :shared_orchestras
    has_many :shared_tandas
    has_many :playbacks, -> { most_recent.limit(100) }
  end
end
