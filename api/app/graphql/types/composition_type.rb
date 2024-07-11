module Types
  class CompositionType < Types::BaseObject
    field :id, ID, null: true
    field :title, String, null: true
    field :tangotube_slug, String, null: true

    belongs_to :lyricist, null: true
    belongs_to :composer, null: true
    has_many :recordings
    has_many :lyrics
    has_many :composition_lyrics
    has_many :composition_roles
  end
end
