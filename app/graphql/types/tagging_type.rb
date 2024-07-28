module Types
  class TaggingType < Types::BaseObject
    field :id, ID, null: false
    field :tag, Types::TagType, null: false
    field :user, Types::UserType, null: false
  end
end
