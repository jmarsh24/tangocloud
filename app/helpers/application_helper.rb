module ApplicationHelper
  def icon(name, options = {})
    options[:title] ||= name.underscore.humanize
    options[:aria] = true
    options[:nocomment] = true
    options[:variant] ||= :outline
    options[:class] = options.fetch(:class, nil)
    path = options.fetch(:path, "icons/#{options[:variant]}/#{name}.svg")
    icon = path
    inline_svg_tag(icon, options)
  end

  def inline_errors_for(resource, field)
    return if resource.blank?

    if resource.errors[field].present?
      full_message = resource.errors.full_messages_for(field).first
      content_tag(:p, full_message, class: "form-error")
    end
  end
end
