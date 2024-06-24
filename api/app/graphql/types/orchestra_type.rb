module Types
  class OrchestraType < Types::BaseObject
    include Rails.application.routes.url_helpers

    field :id, ID, null: true
    field :name, String, null: true
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :rank, Integer, null: true
    field :sort_name, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true
    field :slug, String, null: true
    field :recordings_count, Integer, null: true
    field :photo, AttachedType, null: true

    def photo
      dataloader
        .with(GraphQL::Sources::ActiveStorageHasOneAttached, :photo)
        .load(object)
    end

    has_many :compositions
    has_many :singers
    has_many :lyricists
    has_many :recordings
  end
end
