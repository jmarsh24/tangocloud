module Types
  class OrchestraType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String
    field :sort_name, String

    has_many :orchestra_periods
    has_many :orchestra_positions
    has_many :orchestra_roles
    has_many :singers
    has_many :genres
    has_many :compositions
    has_many :recordings
    has_one_attached :image
  end
end
