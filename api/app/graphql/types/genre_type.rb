module Types
  class GenreType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :recordings, [RecordingType], null: false
    def recordings
      dataloader.with(Sources::Preload, :recordings).load(object)
      object.recordings
    end
  end
end
