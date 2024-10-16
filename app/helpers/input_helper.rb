module InputHelper
  def inline_errors_for(resource, field)
    return if resource.blank?

    if resource.errors[field].present?
      full_message = resource.errors.full_messages_for(field).first
      content_tag(:span, full_message, class: "text-xs text-red-500")
    end
  end

  def error_class(resource, fields)
    fields = Array(fields)
    (fields.any? { |field| resource.errors[field].present? }) ? "input-error" : ""
  end
end
