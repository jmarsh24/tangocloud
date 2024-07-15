module Types
  class TaggingType < Types::BaseObject
    field :id, ID, null: false

    belongs_to :tag
    belongs_to :user
  end
end
