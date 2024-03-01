module Types
  class SingerType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :slug, String, null: true
    field :rank, Integer, null: true
    field :sort_name, String, null: true
    field :bio, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true

    field :recordings, [RecordingType], null: false

    def recordings
      dataloader.with(Sources::Preload, :recordings).load(object)
    end

    field :recording_singers, [RecordingSingerType], null: false

    def recording_singers
      dataloader.with(Sources::Preload, :recording_singers).load(object)
    end
  end
end
