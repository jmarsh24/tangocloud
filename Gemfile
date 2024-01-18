# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read(File.join(__dir__, '.ruby-version')).strip

# Core
gem 'puma'
gem 'rails', '7.1.3'

# Performance
gem 'bootsnap', require: false
gem 'oj'

# Extensions
gem 'acts_as_list'
gem 'acts-as-taggable-on'
gem 'acts_as_votable'
gem 'apollo_upload_server'
gem 'authentication-zero'
gem 'avo'
gem 'bcrypt'
gem 'dotenv-rails'
gem 'faker'
gem 'faraday'
gem 'friendly_id'
gem 'graphiql-rails'
gem 'graphql'
gem 'groupdate'
gem 'kamal'
gem 'kaminari'
gem 'litestack'
gem 'progress_bar'
gem 'pundit'
gem 'rack-cors'
gem 'rails-i18n'
gem 'shimmer'
gem 'slim-rails'
gem 'socialization'
gem 'strong_migrations'
gem 'translate_client'
gem 'yael'

# Assets
gem 'image_processing'
gem 'propshaft'
gem 'ruby-vips'

# External Services
gem 'aws-sdk-s3', require: false
gem 'barnes'
gem 'newrelic_rpm'
gem 'sentry-rails'
gem 'sentry-ruby'

group :development, :test do
  gem 'capybara'
  gem 'cuprite'
  gem 'debug'
  gem 'i18n-tasks'
  gem 'rack_session_access'
  gem 'rspec-rails'
  gem 'rubocop-graphql', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'standard'
end

group :development do
  gem 'annotate'
  gem 'chusaku'
  gem 'guard'
  gem 'guard-rspec'
  gem 'letter_opener'
  gem 'listen'
  gem 'pry-rails'
  gem 'rb-fsevent'
  gem 'web-console'
end

group :test do
  gem 'rspec-retry'
  gem 'webmock'
end
