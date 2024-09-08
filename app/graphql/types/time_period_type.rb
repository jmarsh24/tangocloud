module Types
  class TimePeriodType < Types::BaseObject
    field :description, String, null: true
    field :end_year, Integer, null: true
    field :id, ID, null: false
    field :name, String, null: true
    field :slug, String, null: true
    field :start_year, Integer, null: true

    has_many :recordings
    has_one_attached :image
  end
end
