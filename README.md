# TangoCloud

This is a music streaming platform for tango.

## Release
[![CD](https://github.com/jmarsh24/tangocloud/actions/workflows/deploy.yml/badge.svg?branch=main)](https://github.com/jmarsh24/tangocloud/actions/workflows/deploy.yml)
[![CI](https://github.com/jmarsh24/tangocloud/actions/workflows/ci.yml/badge.svg)](https://github.com/jmarsh24/tangocloud/actions/workflows/ci.yml)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

## Getting Started

Clone the repo with this link. `https://github.com/jmarsh24/tangocloud.git`

### Repository

Make sure the nerdgeschoss development is running correctly (https://github.com/nerdgeschoss/development-environment) and follow the usual setup steps outlined there.

Then install dependencies and prepare the database with:

Make sure you have ruby version **3.2.2** up and running on your local dev environment.

In order to get the project up and running you can use `bin/setup`. This will create a database and install any missing packages. (This has been written for mac OS, so it may not install some dependencies...)

To start the server you can run `bin/dev`. This will start the worker and web processes. The server api server will be available at `localhost:3000`

If you need to add any secrets to the repository you can request the RAILS_MASTER_KEY from the project administrator. Once you have this key all the environment variables can be viewed/edited by running

`bin/rails credentials:edit`

### Run Tests
You can watch any changes and run tests on that specific file by running the command `bin/guard`. 
If you would like to run a specific test once you can run `bin/rspec`

### Linting
Run `bin/rubocop -A` in order lint the ruby.

## Built With

[Ruby on Rails]([http://www.dropwizard.io/1.0.2/docs/](https://rubyonrails.org/)) - The back-end framework
[React Native]([https://maven.apache.org/](https://reactnative.dev/)) - The front-end framework
[Expo Dev]([https://rometools.github.io/rome/](https://expo.dev/)) - iOS and Android Deployment







