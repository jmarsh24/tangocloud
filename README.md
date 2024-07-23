# TangoCloud

## Table of Contents
- [Description](#description)
- [Release](#release)
- [Built With](#built-with)
- [Repository Setup](#repository-setup)
- [Asset Management](#asset-management)
- [Development](#development)
- [Testing](#testing)
- [Linting](#linting)
- [Deployment](#deployment)

This is a music streaming platform for tango.

## Release
[![api](https://github.com/jmarsh24/tangocloud/actions/workflows/test.yml/badge.svg?branch=main&event=status)](https://github.com/jmarsh24/tangocloud/actions/workflows/test.yml)

## Description

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

Clone the repo with this link. `https://github.com/jmarsh24/tangocloud.git`

## Built With

- [Ruby on Rails 7.1.3](https://rubyonrails.org/) - The back-end framework
- [React Native](https://reactnative.dev/) - The front-end framework
- [Expo Dev](https://expo.dev/) - iOS and Android Deployment
- [Postgres](https://postgres.com/) - Database and caching
- [Docker](https://docker.com/) - Deployment and containerization


### Repository

Make sure the nerdgeschoss development is running correctly (https://github.com/nerdgeschoss/development-environment) and follow the usual setup steps outlined there. This will create a docker server to run the postgres database.

Then install dependencies and prepare the database with:

Make sure you have ruby version **3.2.2** up and running on your local dev environment.

In order to get the project up and running you can use `bin/setup`. This will create a database and install any missing packages. (This has been written for mac OS, so it may not install some dependencies...)

To start the server you can run `bin/dev`. This will start the worker and web processes. The server api server will be available at `localhost:3000`

If you need to add any secrets to the repository you can request the RAILS_MASTER_KEY from the project administrator. Once you have this key all the environment variables can be viewed/edited by running

`bin/rails credentials:edit`

## Asset Management

This project uses [Vite](https://vitejs.dev) to manage assets. This gives us the capability to have live reload in the project.

## Development
For debugger this project uses the [debug](https://github.com/ruby/debug) gem. A breakpoint can be added in the ruby code with `binding.irb` or by using the alias `debugger`.

For future development, please consult the [nerdgeschoss NUTS handbook](https://nerdgeschoss.de/handbook/nuts) for current developer guidelines.

## Testing

This project using [rspec](https://github.com/rspec/rspec-rails) for testing. You can run the test suite using `bin/guard`

Before running tests, `bin/rails assets:precompile` should be run, otherwise the javascript and css will not be compiled.

Be default the system tests run without a head. If you would like to enable headful browsing in system tests for debugging you can change `HEADLESS=true` in the `.env` file.

## Linting

This project uses linting provided by [rubocop](https://github.com/rubocop/rubocop) with customization added by [shimmer](https://github.com/nerdgeschoss/shimmer).

It also uses [Shopify LSP](https://github.com/Shopify/ruby-lsp) to improve the editor experience.

In order to run ruby linting across the code you can run `bin/rubocop -A` which will try to auto correct any mistakes.
