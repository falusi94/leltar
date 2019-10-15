[![Maintainability](https://api.codeclimate.com/v1/badges/afb57353632e7743da3f/maintainability)](https://codeclimate.com/github/falusi94/leltar/maintainability)

# README

Simple inventory management system built on Ruby on Rails. It can easily manage separated faculties (called groups), search using elastic search, export using ransack, import from google sheets, and has some basic status report.

## System requirements
* Tested with 2.4.2 and 2.3.7
* PostgreSQL for production/development (maybe easily can change to other)
* SqLite3 for tests
* Elasticsearch for searchkick

OR

* docker with compose

## Configuration
For local development or any non dockerized running just .env.example to .env and add parametes. If you want to use .env in production, update the Gemfile according to, and move the dotenv gem to all environment. For development check or update config/database.yml too.

For the first time (and after every related modification) run elastic's reindexing:
```ruby
rails runner 'Item.reindex'
rails runner 'Group.reindex'
```

## Database creation and initialization
After proper set database just run the seeder. It gives an admin user with admin@sch.hu/foobar login.


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

`docker-compose up --build`

After the creating, while the containers are runing run the following commands:

```shell
# This is only necessary at new setups
docker-compose run web bash -c "RAILS_ENV=production bundle exec rake db:setup"
# This is only necessary after pending migrations
docker-compose run web bash -c "RAILS_ENV=production bundle exec rake db:migrate"
# These are requires after changing searchkick settings
docker-compose run web bash -c "RAILS_ENV=production rails runner 'Item.reindex'"
docker-compose run web bash -c "RAILS_ENV=production rails runner 'Group.reindex'"
```
