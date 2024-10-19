Rails.application.config.generators do |g|
  g.orm :active_record, primary_key_type: :uuid
  g.integration_tool :minitest
  g.test_framework :minitest, spec: true, fixture: true
  g.view_specs false
  g.request_specs false
  g.helper_specs false
  g.system_tests false
end
