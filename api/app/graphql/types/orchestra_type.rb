module Types
  class OrchestraType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :rank, Integer, null: true
    field :sort_name, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: true
    field :recordings_count, Integer, null: true

    field :compositions, [CompositionType], null: false
    def compositions
      dataloader.with(Sources::Preload, :compositions).load(object)
    end

    field :recordings, [RecordingType], null: false
    def recordings
      dataloader.with(Sources::Preload, :recordings).load(object)
    end

    field :singers, [SingerType], null: false
    def singers
      dataloader.with(Sources::Preload, :singers).load(object)
    end

    field :lyricists, [LyricistType], null: false
    def lyricists
      dataloader.with(Sources::Preload, :lyricists).load(object)
    end
  end
end
