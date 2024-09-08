module Types
  class CompositionType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: true

    has_many :recordings
    has_many :lyrics
    has_many :composition_lyrics
    has_many :composition_roles
  end
end
