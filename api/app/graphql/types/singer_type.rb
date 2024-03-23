module Types
  class SingerType < Types::BaseObject
    include Rails.application.routes.url_helpers

    field :id, ID, null: true
    field :name, String, null: true
    field :slug, String, null: true
    field :rank, Integer, null: true
    field :sort_name, String, null: true
    field :bio, String, null: true
    field :birth_date, GraphQL::Types::ISO8601Date, null: true
    field :death_date, GraphQL::Types::ISO8601Date, null: true

    field :photo_url, String, null: true

    def photo_url
      dataloader.with(Sources::Preload, photo_attachment: :blob).load(object)
      cdn_image_url(object.photo.variant(:large))
    end

    has_many :recording_singers
    has_many :recordings
  end
end
