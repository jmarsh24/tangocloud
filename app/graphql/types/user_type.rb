module Types
  class UserType < BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :email, String, null: false
    field :id, ID, null: false
    field :provider, String
    field :role, String, null: false
    field :uid, String
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :username, String
    def role
      object.role.titleize
    end

    has_one_attached :avatar

    has_many :likes, -> { most_recent }
    has_many :liked_recordings, type: Types::RecordingType
    has_many :tandas
    has_many :playlists
    has_many :playlist_items
    has_many :taggings
    has_many :tags
    has_many :shares
    has_many :shared_recordings, type: Types::ShareType
    has_many :shared_playlists, type: Types::ShareType
    has_many :shared_orchestras, type: Types::ShareType
    has_many :shared_tandas, type: Types::ShareType
    has_many :playbacks, -> { most_recent.limit(100) }
  end
end
