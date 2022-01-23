[![Maintainability](https://api.codeclimate.com/v1/badges/afb57353632e7743da3f/maintainability)](https://codeclimate.com/github/falusi94/leltar/maintainability)

# README

Simple inventory management system built on Ruby on Rails. It can easily manage separated faculties (called groups), export using ransack, import from google sheets, and has some basic status report.

**Disclaimer**: this is an abandoned project w/o any vision, so I decided to get it into shape & convert it to a playground.

## System requirements
* Ruby 2.5.7 ([asdf-vm](https://asdf-vm.com/#/core-manage-asdf-vm) and [asdf-ruby](https://github.com/asdf-vm/asdf-ruby))
* PostgreSQL

OR

* docker with compose

## Configuration
For local development or any non dockerized running just .env.example to .env and add parametes. If you want to use .env in production, update the Gemfile according to, and move the dotenv gem to all environment. For development check or update config/database.yml too.

## Database creation and initialization
After proper set database just run the seeder. It gives an admin user with admin@example.org/foobar login.


## Deployment instructions
Easy deployment could be achieved with Docker and Docker-compose. I suggest to create two volumes for db data and public data, to easily find later these volumes. Then you need to set some variables, so open `docker-compose.yml`, then modify the following lines:

```yaml
# Add your volumes
public_folder:
  external:
    name: your_public_volume
database_folder:
  external:
    name: your_db_volume
```

Just run the following:

```shell
# Generate secret keybase if necessary
bundle exec rake secret
docker-compose up --build --build-arg SECRET_KEYBASE=you_key_base
```

After the creating, while the containers are runing run the following commands:

```shell
# This is only necessary at new setups
docker-compose run web bash -c "RAILS_ENV=production bundle exec rake db:setup"
# This is only necessary after pending migrations
docker-compose run web bash -c "RAILS_ENV=production bundle exec rake db:migrate"
```
