module Types
  class AttachmentType < Types::BaseObject
    field :url, String, null: false
    field :content_type, String, null: false
    field :filename, String, null: false
    field :byte_size, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    belongs_to :blob
  end
end
