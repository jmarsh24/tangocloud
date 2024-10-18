ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"
require "vcr"

Dir[Rails.root.join("test/support/**/*.rb")].sort.each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = "test/vcr_cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
  # c.ignore_hosts "chromedriver.storage.googleapis.com", "googlechromelabs.github.io", "edgedl.me.gvt1.com"
end
class ActiveSupport::TestCase
  # setup do
  #   @@once ||= begin
  #     MeiliSearch::Rails::Utilities.reindex_all_models
  #     true
  #   end
  # end

  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end
