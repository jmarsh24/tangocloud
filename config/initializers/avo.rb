Avo.configure do |config|
  config.root_path = "/admin"
  config.app_name = "TangoCloud"
  config.per_page_steps = [48, 96, 256]
  config.full_width_index_view = true
  config.full_width_container = true
  config.cache_resources_on_index_view = true
  config.raise_error_on_missing_policy = true
  config.home_path = -> { resources_playlists_path }
  config.license_key = Rails.application.credentials.dig(:avo_license_key)
  config.cache_store = -> {
    ActiveSupport::Cache.lookup_store(:solid_cache_store)
  }
end
