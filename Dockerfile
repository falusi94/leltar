FROM ruby:2.5
RUN apt-get update -qq &&\
    apt-get install -y build-essential libpq-dev nodejs libssl1.0-dev imagemagick

RUN mkdir /leltar
WORKDIR /letar

# Install dependencies
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

# Copy application
COPY . .

# Build app and run migrations
RUN RAILS_ENV=production bundle exec rake assets:precompile
