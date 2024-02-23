class ImageVariant < GraphQL::Schema::Enum
  description <<~DESC
    Image variant generated with libvips via the image_processing gem.
    Read more about options here https://github.com/janko/image_processing/blob/master/doc/vips.md#methods
  DESC

  ActiveStorage.transformations.each do |key, options|
    value key.to_s, options.map { |k, v| "#{k}: #{v}" }.join("\n"), value: key
  end
end
