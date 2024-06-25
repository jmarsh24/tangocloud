module Types
  class BlobType < GraphQL::Schema::Object
    field :content_type, String, null: false
    field :filename, String, null: false
    field :byte_size, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :metadata, GraphQL::Types::JSON, null: true
    field :url, String, null: false do
      argument :width, Integer, required: false
    end

    def url(width: nil)
      if object.image? && object.variable?
        object.variant(resize: "100x100", imgproxy_options: {width:})
      else
        Rails.application.routes.url_helpers.rails_blob_url(object)
      end
    end
  end
end
