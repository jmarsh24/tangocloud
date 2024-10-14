module Types
  class AttachedType < Types::BaseObject
    field :byte_size, Integer, null: false
    field :content_type, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :filename, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :url, String, null: false do
      argument :format, String, required: false, default_value: "jpg"
      argument :height, Integer, required: false
      argument :resizing_type, String, required: false, default_value: "fit"
      argument :width, Integer, required: false
    end

    def url(width: nil, height: nil, resizing_type: "fit", format: "jpg")
      if object.image? && object.variable?
        variant = object.variant(
          combine_options(width:, height:, resizing_type:, format:)
        ).processed

        Rails.application.routes.url_helpers.url_for(variant)
      else
        Rails.application.routes.url_helpers.url_for(object)
      end
    end

    private

    def combine_options(width:, height:, resizing_type:, format:)
      options = {}

      if width && height
        options[:resize] = "#{width}x#{height}^" if resizing_type == "fit"
        options[:resize] = "#{width}x#{height}" if resizing_type == "limit"
      end

      options[:format] = format if format.present?

      if format == "jpg"
        options[:saver] = {quality: 80}
      elsif format == "png"
        options[:strip] = true
      end

      options
    end
  end
end
