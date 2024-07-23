module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :username, String
    field :admin, Boolean, null: false
    field :provider, String
    field :uid, String
    field :email, String, null: false
    # field :first_name, String
    # field :last_name, String

    # field :password_digest, String, null: false
    # field :password_reset_token, String
    # field :password_reset_sent_at, GraphQL::Types::ISO8601DateTime
    # field :remember_created_at, GraphQL::Types::ISO8601DateTime
    # field :sign_in_count, Integer
    # field :current_sign_in_at, GraphQL::Types::ISO8601DateTime
    # field :last_sign_in_at, GraphQL::Types::ISO8601DateTime
    # field :current_sign_in_ip, String
    # field :last_sign_in_ip, String
    # field :confirmation_token, String
    # field :confirmed_at, GraphQL::Types::ISO8601DateTime
    # field :confirmation_sent_at, GraphQL::Types::ISO8601DateTime
    # field :unconfirmed_email, String

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    has_one :user_preference
    has_many :likes, -> { most_recent }
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
