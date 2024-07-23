module Types
  class BlobType < GraphQL::Schema::Object
    field :byte_size, Integer, null: false
    field :content_type, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :filename, String, null: false
    field :metadata, GraphQL::Types::JSON, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :url, String, null: false do
      argument :width, Integer, required: false
    end

    def url(width: nil)
      if object.image? && object.variable?
        object.imgproxy_url(imgproxy_options: {width: width || 1000})
      else
        Rails.application.routes.url_helpers.rails_blob_url(object)
      end
    end
  end
end
