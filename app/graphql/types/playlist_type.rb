module Types
  class PlaylistType < Types::BaseObject
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :description, String, null: true
    field :id, ID, null: false
    field :public, Boolean, null: false
    field :slug, String, null: true
    field :subtitle, String, null: true
    field :system, Boolean, null: false
    field :title, String, null: false
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
