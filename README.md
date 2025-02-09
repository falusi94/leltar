# README

A simple inventory management system built on Ruby on Rails, providing a full web interface and a WIP API. Feature list:

- Managing separate organisations, departments and items
- Mixed RBAC (organisation level) and ReBAC (department level)
- Advanced search and export with ransack
- Depreciation
- Basic status report

**Disclaimer**: this was an abandoned project w/o any vision, so I decided to get it into shape and convert it into a playground.

## Requirements
* Ruby - check `.tool-versions` ([asdf-vm](https://asdf-vm.com/#/core-manage-asdf-vm) and [asdf-ruby](https://github.com/asdf-vm/asdf-ruby))
* yarn - [instructions](https://classic.yarnpkg.com/lang/en/docs/install/)
* PostgreSQL

## Initialisation
#### Database
First-time users should create a database user defined in the `config/database.yml` or override the DB user/password in the env (using `.env` or env vars), then do the usual Rails setup.

```sh
bin/rails db:create db:schema:load db:seed
```

This creates some test data along with an admin user `admin@example.org`/`foobar`. Also, if there is no organisation when starting the app, the web URL exposes a wizard to set up the first organisation and user.

#### Node modules
```sh
yarn install
```

## Running
Either use the procfile or run the commands defined there in separate consoles.

## Testing
The app is tested via RSpec, though some tests use Capybara and require a browser.

```sh
bundle exec rspec
```

## Docker
The application can be run via Docker. Everything is defined in the `Dockerfile` and `docker-compose.yml` but not actively maintained.
