ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"
require "minitest/mock"
require "vcr"

Dir[Rails.root.join("test/support/**/*.rb")].sort.each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = "test/vcr_cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
  # c.ignore_hosts "chromedriver.storage.googleapis.com", "googlechromelabs.github.io", "edgedl.me.gvt1.com"
end

WebMock.disable_net_connect!({
  allow_localhost: true
})

class ActiveSupport::TestCase
  include AuthHelper
  # setup do
  #   @@once ||= begin
  #     MeiliSearch::Rails::Utilities.reindex_all_models
  #     true
  #   end
  # end

  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in defined order
  fixtures :all

  setup do
    ActiveStorage::Current.url_options = {protocol: "https://", host: "example.com", port: nil}
  end

  teardown do
    ActiveStorage::Current.reset
  end

  def default_url_options
    Rails.application.routes.default_url_options
  end
end

ActiveStorage::FixtureSet.file_fixture_path = File.expand_path("fixtures/files", __dir__)
