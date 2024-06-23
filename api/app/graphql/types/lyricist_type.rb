module Types
  class LyricistType < Types::BaseObject
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

    field :photo_url, String, null: true

    def photo_url
      dataloader.with(Sources::Preload, photo_attachment: :blob).load(object)
      object.photo&.url
    end

    has_many :compositions
    has_many :lyrics
  end
end
