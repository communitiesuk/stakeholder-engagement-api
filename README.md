# README

This app is the backend API behind the [Stakeholder Engagement Prototype](https://github.com/communitiesuk/stakeholder-engagement)

It aims to conform to the [JSON:API](https://jsonapi.org/) standard with respect to output format and query parameters - most notably around [pagination](https://jsonapi.org/format/#fetching-pagination)

## To run locally

After completing the Configuration and Database creation / initialization steps below, you can run a local server with:

`bundle exec rails s`

This will start a server on port 3000 (to change the port, use the `-p` parameter, e.g. `bundle exec rails s -p 3001`)

## Usage

It's a RESTful API - so each resource type has CRUD operations on standard RESTful paths/verbs.
By default, all index requests are paginated to a maximum of 20 per page.
You can
E.g.

To retrieve the first 20 OrganisationTypes:
http://localhost:3000/api/v1/organisation_types.json

To retrieve the second 20 OrganisationTypes:
http://localhost:3000/api/v1/organisation_types.json?page[number]=2

To retrieve the third page of 5 OrganisationTypes, sorted by name:
http://localhost:3000/api/v1/organisation_types.json?page[number]=3&page[size]=5&sort=name

To retrieve the third page of 5 OrganisationTypes, sorted by name in descending order:
http://localhost:3000/api/v1/organisation_types.json?page[number]=3&page[size]=5&sort=-name


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
