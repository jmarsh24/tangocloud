module Types
  class OrchestraType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :slug, String, null: true
    field :sort_name, String, null: true

    has_many :orchestra_periods
    has_many :orchestra_roles
    has_many :singers
    has_many :genres
    has_many :compositions
    has_many :recordings
    has_one_attached :photo
  end
end
