module Types
  class LyricistType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :slug, String, null: true
    field :rank, Integer, null: true
    field :sort_name, String, null: true
    field :bio, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true

    field :lyrics, [LyricType], null: false
    def lyrics
      dataloader.with(Sources::Preload, :lyrics).load(object)
    end

    field :compositions, [CompositionType], null: false
    def compositions
      dataloader.with(Sources::Preload, :compositions).load(object)
    end
  end
end
