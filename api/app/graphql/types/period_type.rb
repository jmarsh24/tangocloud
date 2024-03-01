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
    end
  end
end
