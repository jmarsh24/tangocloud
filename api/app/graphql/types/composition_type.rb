module Types
  class CompositionType < Types::BaseObject
    field :id, ID, null: true
    field :title, String, null: true
    field :tangotube_slug, String, null: true
    field :lyricist, Types::LyricistType, null: true
    field :composer, Types::ComposerType, null: true
    field :recordings, [Types::RecordingType], null: true
    field :lyrics, [Types::LyricType], null: true
  end
end
