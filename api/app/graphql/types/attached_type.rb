module Types
  class AttachedType < GraphQL::Schema::Object
    field :url, String, null: false
    field :content_type, String, null: false
    field :filename, String, null: false
    field :byte_size, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    def url
      Rails.application.routes.url_helpers.cdn_image_url(object, only_path: true)
    end
  end
end
