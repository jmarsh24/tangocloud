Rails.application.configure do
  config.lograge.enabled = true
  # mute active storage log entries
  config.lograge.ignore_actions = [
    "ActiveStorage::DiskController#show",
    "ActiveStorage::RepresentationsController#show"
  ]
end
