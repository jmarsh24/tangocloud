module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :password_digest, String, null: false
    field :verified, Boolean, null: false
    field :provider, String
    field :uid, String
    field :username, String, null: true
    field :name, String, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :admin, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    has_many :sessions
    has_many :events
    has_many :listens, -> { most_recent.limit(100) }
    has_many :playlists
    has_many :likes, -> { most_recent }
    has_one_attached :avatar
  end
end
