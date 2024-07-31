module Types
  class TaggingType < Types::BaseObject
    field :id, ID, null: false
    field :tag, Types::TagType, null: false

    belongs_to :user
  end
end
