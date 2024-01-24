# frozen_string_literal: true

Avo.configure do |config|
  config.current_user_method = :current_user
  config.per_page_steps = [48, 96, 256]
  config.id_links_to_resource = true
  config.resource_controls_placement = :left
  config.full_width_index_view = true
  config.full_width_container = true
  config.cache_resources_on_index_view = true
  config.raise_error_on_missing_policy = true
end
