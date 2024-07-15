module Types
  class ElRecodoSongType < Types::BaseObject
    field :album, String, null: true
    field :artist, String, null: true
    field :author, String, null: true
    field :composer, String, null: true
    field :date, GraphQL::Types::ISO8601Date, null: true
    field :ert_number, Integer, null: true
    field :id, ID, null: true
    field :label, String, null: true
    field :lyrics, String, null: true
    field :music_id, Integer, null: true
    field :orchestra, String, null: true
    field :singer, String, null: true
    field :style, String, null: true
    field :title, String, null: true

    belongs_to :recording
  end
end
