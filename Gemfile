source "https://rubygems.org"
ruby File.read(File.join(__dir__, ".ruby-version")).strip

# Core
gem "puma"
gem "rails", "7.2.1"

# Database
gem "pg"

# Performance
gem "bootsnap", require: false
gem "oj"

# Extensions
gem "acts_as_list"
gem "apollo_upload_server"
gem "avo"
gem "bcrypt"
gem "chunky_png"
gem "dotenv-rails"
gem "faraday"
gem "faraday-follow_redirects"
gem "faraday-cookie_jar"
gem "faraday-retry"
gem "friendly_id"
gem "graphql"
gem "graphiql-rails"
gem "graphql-sources"
gem "groupdate"
gem "jwt"
gem "kaminari"
gem "omniauth"
gem "omniauth-rails_csrf_protection"
gem "progress_bar"
gem "pundit"
gem "rack-cors"
gem "rails-i18n"
gem "socialization"
gem "solid_cache"
gem "translate_client"
gem "solid_queue"
gem "mission_control-jobs"
gem "streamio-ffmpeg"
gem "elasticsearch"
gem "searchkick"
gem "googleauth"
gem "inline_svg"
gem "lograge"
gem "dry-monads"
gem "imgproxy-rails"
gem "active_storage_validations"
gem "devise"
gem "jwt_sessions"
gem "redis"
gem "kamal", require: false

# Assets
gem "stimulus-rails"
gem "image_processing"
gem "propshaft"
gem "ruby-vips"
gem "vite_rails"
gem "turbo-rails"
gem "thruster", require: false

# External Services
gem "aws-sdk-s3", require: false
gem "newrelic_rpm"
gem "sentry-rails"
gem "sentry-ruby"

group :development, :test do
  gem "capybara"
  gem "capybara-playwright-driver"
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "i18n-tasks"
  gem "rack_session_access"
  gem "rspec-rails"
  gem "rubocop-graphql", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "standard"
  gem "ruby-lsp-rspec", require: false
  gem "faker"
  gem "factory_bot_rails"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "annotate"
  gem "chusaku"
  gem "guard"
  gem "guard-rspec"
  gem "listen"
  gem "letter_opener"
  gem "pry-rails"
  gem "rb-fsevent"
  gem "web-console"
  gem "brakeman", require: false
  gem "database_validations"
  gem "database_consistency", require: false
  gem "ruby-progressbar"
end

group :test do
  gem "rspec-retry"
  gem "webmock"
end
