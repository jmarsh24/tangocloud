module Types
  class SingerType < Types::BaseObject
    include Rails.application.routes.url_helpers

    field :id, ID, null: true
    field :name, String, null: true
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :slug, String, null: true
    field :rank, Integer, null: true
    field :sort_name, String, null: true
    field :bio, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true
    field :soloist, Boolean, null: false
    field :photo, AttachedType, null: true

    def photo
      dataloader
        .with(GraphQL::Sources::ActiveStorageHasOneAttached, :photo)
        .load(object)
    end

    has_many :recording_singers
    has_many :recordings
  end
end
