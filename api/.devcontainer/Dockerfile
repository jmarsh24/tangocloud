# syntax = docker/dockerfile:1
ARG NODE_VERSION=20.10.0

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2
FROM mcr.microsoft.com/devcontainers/ruby:1-${RUBY_VERSION}-bullseye

# Prepare for Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

RUN wget -O- https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list

RUN wget -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgres.list

# Install additional OS packages.
RUN apt-get update && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install --no-install-recommends \
  software-properties-common terraform gh libvips42 postgresql-client-15 python3-pip ffmpeg curl

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

RUN curl -fsSL https://get.docker.com | sh

RUN . /usr/local/share/nvm/nvm.sh \
  && nvm install 20.10.0

RUN npm install -g heroku

RUN gem install rails pull-request

RUN npx playwright install-deps && npx playwright install chromium
