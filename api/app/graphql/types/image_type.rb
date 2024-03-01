module Types
  class ImageType < Types::BaseObject
    field :id, ID, null: false
    field :url, String, null: false
  end
end
