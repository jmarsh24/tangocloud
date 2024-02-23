class ImageUrlField < GraphQL::Schema::FieldExtension
  attr_reader :attachment_assoc

  def apply
    # Here we try to define the attachment name:
    # - it could be set explicitly via extension options
    # - or we imply that is the same as the field name w/o "_url"
    # suffix (e.g., "avatar_url" => "avatar")
    attachment = options&.[](:attachment) || field.original_name.to_s.sub(/_url$/, "")

    # that's the name of the Active Record association
    @attachment_assoc = "#{attachment}_attachment"

    # Defining an argument for the field
    field.argument(
      :variant,
      ImageVariant,
      required: false
    )
  end

  # This method resolves (as it states) the field itself
  # (it's the same as defining a method within a type)
  def resolve(object:, **_rest)
    AssociationLoader.for(
      object.class,
      # that's where we use our association name
      attachment_assoc => :blob
    )
  end

  # This method is called if the result of the `resolve`
  # is a lazy value (e.g., a Promise—like in our case)
  def after_resolve(value:, arguments:, **_rest)
    return if value.nil?

    variant = arguments.fetch(:variant, :medium)
    value = value.variant(variant) if variant

    Rails.application.routes.url_helpers.url_for(value)
  end
end
