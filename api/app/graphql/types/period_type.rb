module Types
  class PeriodType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :description, String, null: true
    field :start_year, Integer, null: true
    field :end_year, Integer, null: true
    field :recordings_count, Integer, null: true
    field :slug, String, null: true

    field :recordings, [RecordingType], null: false

    def recordings
      dataloader.with(Sources::Preload, :recordings).load(object)
      object.recordings
    end

    field :image_url, String, null: true

    def image_url
      dataloader.with(Sources::Preload, image_attachment: :blob).load(object)
      object.image&.url
    end
  end
end
