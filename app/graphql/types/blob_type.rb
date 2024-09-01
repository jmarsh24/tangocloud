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
      argument :height, Integer, required: false
      argument :resizing_type, String, required: false, default_value: "fit"
      argument :format, String, required: false, default_value: "jpg"
    end

    def url(width: nil, height: nil, resizing_type: "fit", format: "jpg")
      if object.image? && object.variable?
        imgproxy_options = {width:, height:, resizing_type:, format:}.compact
        Rails.application.routes.url_helpers.imgproxy_active_storage_url(object, **imgproxy_options)
      else
        Rails.application.routes.url_helpers.imgproxy_active_storage_url(object)
      end
    end
  end
end
