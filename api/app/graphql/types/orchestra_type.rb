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

    def name
      object.formatted_name
    end

    field :compositions, [CompositionType], null: false
    def compositions
      dataloader.with(Sources::Preload, :compositions).load(object)
      object.compositions
    end

    field :singers, [SingerType], null: false
    def singers
      dataloader.with(Sources::Preload, :singers).load(object)
      object.singers
    end

    field :lyricists, [LyricistType], null: false
    def lyricists
      dataloader.with(Sources::Preload, :lyricists).load(object)
      object.lyricists
    end

    has_many :recordings
  end
end
