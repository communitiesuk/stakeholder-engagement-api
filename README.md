# README

This app is the backend API behind the [Stakeholder Engagement Prototype](https://github.com/communitiesuk/stakeholder-engagement)

## Ruby version

Developed & tested with Ruby 2.5.3. Any version from 2.0.0 would _probably_ work, but this has not been tested.

## System dependencies

A PostgreSQL database
Ruby
rubygems
Bundler

## Configuration

This app is developed according to [12-Factor App Principles](https://12factor.net/) - it takes all required configuration from environment variables. It uses the dotenv gem to load these from a .env file if one is present.

The environment variables required are:

* DATABASE_URL
  A fully-scoped URL to a PostgreSQL database, typically in the form
  postgres://{user}:{password}@{hostname}:{port}/{database-name}

## Database creation

`bundle exec rails db:create`

## Database initialization

`bundle exec rails db:setup`

## How to run the test suite

`bundle exec rspec`

## Services (job queues, cache servers, search engines, etc.)

None yet

## Deployment instructions

TBD

* ...
