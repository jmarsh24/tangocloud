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

## Rake Tasks

### Update El Recodo Seed Data
The El Recodo seed data is stored in SQL files under `db/seeds`. The seeds can be updated by running the rake task below.
`bin/rails db:export:el_recodo`

### Import Audio Files From Music Folder
The music folder on your computer is mounted to the devcontainer. To import these files into the application you can run this rake task.
`bin/rails audio_files:import_from_music`

