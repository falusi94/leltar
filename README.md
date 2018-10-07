# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
Tested with 2.4.2 and 2.3.7

* System dependencies
Need postgresql for production and development and sqlite3 for test. Needs elastic search running for searchkick.

* Configuration
Copy .env.example to .env and add parametes. For development check or update config/database.yml

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

## Deployment instructions

Easy deployment could be achieved with Docker and Docker-compose. First you need to set some variables, so open `docker-compose.yml`, then modify the following lines:

```yaml
environment:
  # Add your secret key
  - SECRET_KEY_BASE=

...

# Add your volumes
volumes:
  public-folder:
  database-data:

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
