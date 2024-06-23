# syntax = docker/dockerfile:1
ARG NODE_VERSION=20.10.0

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM mcr.microsoft.com/devcontainers/ruby:1-$RUBY_VERSION-bullseye as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
  BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development"

# Install packages needed for deployment
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y curl postgresql-client-15 libvips ffmpeg software-properties-common \
  python3-pip watchman && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Install packages needed for audiowaveform
RUN apt-get update -qq && \
  apt-get install -y make cmake gcc g++ libmad0-dev \
  libid3tag0-dev libsndfile1-dev libgd-dev libboost-filesystem-dev \
  libboost-program-options-dev libboost-regex-dev && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# install audiowaveform
RUN curl -LO https://github.com/bbc/audiowaveform/releases/download/1.10.1/audiowaveform_1.10.1-1-12_arm64.deb && \
  dpkg -i audiowaveform_1.10.1-1-12_arm64.deb && \
  rm audiowaveform_1.10.1-1-12_arm64.deb

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential git libpq-dev node-gyp pkg-config python-is-python3

# Install JavaScript dependencies
ARG NODE_VERSION=20.10.0
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
  /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
  npm install -g yarn && \
  rm -rf /tmp/node-build-master

# Install application gems
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
  bundle exec bootsnap precompile --gemfile

RUN gem install rails pull-request

RUN npx playwright install-deps && npx playwright install chromium

# Install node modules
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
  chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
