require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "webmock/rspec"
require "pundit/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActiveJob::TestHelper

  config.fixture_paths = [Rails.root.join("spec/fixtures").to_s]
  config.use_transactional_fixtures = true
  config.global_fixtures = :all
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  config.before(:each) do
    ActiveStorage::Current.url_options = {host: "example.com"}
  end
end
