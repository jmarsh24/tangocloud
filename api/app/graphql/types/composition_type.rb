module Types
  class CompositionType < Types::BaseObject
    field :id, ID, null: true
    field :title, String, null: true
    field :tangotube_slug, String, null: true

    field :recordings, [RecordingType], null: false

    def recordings
      dataloader.with(Sources::Preload, :recordings).load(object)
    end

    field :lyrics, [LyricType], null: false

    def lyrics
      dataloader.with(Sources::Preload, :lyrics).load(object)
    end

    belongs_to :lyricist
    belongs_to :composer
  end
end
