module Types
  class PlaybackType < Types::BaseObject
    field :id, ID, null: false
    field :duration, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :recording
    belongs_to :user
  end
end
