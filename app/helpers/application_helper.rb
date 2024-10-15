module ApplicationHelper
  def inline_errors_for(resource, field)
    return if resource.blank?

    if resource.errors[field].present?
      full_message = resource.errors.full_messages_for(field).first
      content_tag(:p, full_message, class: "form-error")
    end
  end
end
