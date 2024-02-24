module Types
  class CompositionType < Types::BaseObject
    field :id, ID, null: true
    field :title, String, null: true
    field :tangotube_slug, String, null: true

    belongs_to :lyricist
    belongs_to :composer
    has_many :recordings
    has_many :lyrics
  end
end
