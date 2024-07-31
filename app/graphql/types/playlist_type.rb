module Types
  class PlaylistType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :subtitle, String, null: true
    field :description, String, null: true
    field :slug, String, null: true
    field :public, Boolean, null: false
    field :system, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :user
    has_many :playlist_items
    has_many :shares
    has_many :likes
    has_many :tandas
    has_many :recordings
    has_one_attached :image
  end
end
