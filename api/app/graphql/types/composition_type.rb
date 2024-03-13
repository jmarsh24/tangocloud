module Types
  class CompositionType < Types::BaseObject
    field :id, ID, null: true
    field :title, String, null: true
    field :tangotube_slug, String, null: true
    field :lyrics, [LyricType], null: false

    def lyrics
      dataloader.with(Sources::Preload, :lyrics).load(object)
      object.lyrics
    end

    belongs_to :lyricist
    belongs_to :composer
    has_many :recordings
  end
end
