Avo.configure do |config|
  config.app_name = "TangoCloud"
  config.per_page_steps = [48, 96, 256]
  config.full_width_index_view = true
  config.full_width_container = true
  config.cache_resources_on_index_view = true
  config.raise_error_on_missing_policy = true
  config.home_path = -> { resources_playlists_path }
  config.license_key = Config.avo_license_key
end
