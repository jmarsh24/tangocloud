module Types
  class AttachmentType < Types::BaseObject
    field :byte_size, Integer, null: false
    field :content_type, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :filename, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :url, String, null: false

    has_one :blob
  end
end
