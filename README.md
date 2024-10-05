# Tangocloud.app

[Tangocloud.app](https://www.Tangocloud.app)

## Release
[![api](https://github.com/jmarsh24/tangocloud/actions/workflows/test.yml/badge.svg?branch=main&event=status)](https://github.com/jmarsh24/tangocloud/actions/workflows/test.yml)

Technically the project is built using the lastest Ruby and Rails goodies such as Hotwire, SolidQueue, SolidCache. For the front end part we use Vite, Tailwind and Stimulus.

It is deployed on an [Hetzner VPS]() with Kamal with Postgres as the main database.

## Getting Started

We have tried to make the setup process as simple as possible so that in a few commands you can have the project with real data running locally.

### Requirements

- Ruby 3.3.5
- Docker and docker-compose (for Elasticsearch)
- Node.js 20.11.0
- Elasicsearch 8.11

### Setup

To prepare your database and seed content, run:

```
bin/setup
```

### Environment Variables

You can use the `.env.sample` file as a guide for the environment variables required for the project. However, there are currently no environment variables necessary for simple app exploration.

### Elasticsearch

[Tangocloud.app](https://www.Tangocloud.app) search uses Elasticsearch as a search engine.

To start the app, you need to have a Elasticsearch service started. There is a Docker Compose available

In a new terminal :

```
docker-compose up
```

### Starting the Application

The following command will start Rails, SolidQueue and Vite (for CSS and JS).

```
bin/dev
```

## Linter

The CI performs 3 checks:

- erblint
- standardrb
- standard (js)

Before committing your code you can run `bin/lint` to detect and potentially autocorrect lint errors.

To follow Tailwind CSS's recommended order of classes, you can use [Prettier](https://prettier.io/) along with the [prettier-plugin-tailwindcss](https://github.com/tailwindlabs/prettier-plugin-tailwindcss), both of which are included as devDependencies. This formating is not yet enforced by the CI.

## License

Tangocloud.app is open source and available under the MIT License. For more information, please see the [License](/LICENSE.md) file.

## Useful Rake Tasks

### Update El Recodo Seed Data
The El Recodo seed data is stored in SQL files under `db/seeds`. The seeds can be updated by running the rake task below.
`bin/rails db:export:el_recodo`

### Import Audio Files From Music Folder
The music folder on your computer is mounted to the devcontainer. To import these files into the application you can run this rake task.
`bin/rails audio_files:import_from_music`

