module Types
  class TagType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false

    has_many :taggings
  end
end
