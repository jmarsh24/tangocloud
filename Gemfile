# frozen_string_literal: true

source "https://rubygems.org"
ruby File.read(File.join(__dir__, ".ruby-version")).strip

# Core
gem "rails", "7.1.3"
gem "puma"

# Database
gem "pg"
gem "litestack"

# Performance
gem "oj"
gem "bootsnap", require: false

# Extensions
gem "authentication-zero"
gem "acts_as_list"
gem "acts-as-taggable-on"
gem "acts_as_votable"
gem "apollo_upload_server"
gem "avo"
gem "bcrypt"
gem "dotenv-rails"
gem "faker"
gem "faraday"
gem "friendly_id"
gem "graphiql-rails"
gem "graphql"
gem "groupdate"
gem "kamal"
gem "kaminari"
gem "pundit"
gem "progress_bar"
gem "rack-cors"
gem "shimmer"
gem "slim-rails"
gem "socialization"
gem "strong_migrations"
gem "translate_client"
gem "rails-i18n"
gem "yael"

# Assets
gem "ruby-vips"
gem "image_processing"
gem "propshaft"

# External Services
gem "newrelic_rpm"
gem "aws-sdk-s3", require: false
gem "barnes"
gem "sentry-ruby"
gem "sentry-rails"

group :development, :test do
  gem "rspec-rails"
  gem "standard"
  gem "capybara"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-graphql", require: false
  gem "cuprite"
  gem "i18n-tasks"
  gem "rack_session_access"
  gem "debug"
end

group :development do
  gem "listen"
  gem "web-console"
  gem "annotate"
  gem "rb-fsevent"
  gem "letter_opener"
  gem "pry-rails"
  gem "guard"
  gem "guard-rspec"
  gem "chusaku"
end

group :test do
  gem "rspec-retry"
  gem "webmock"
end
