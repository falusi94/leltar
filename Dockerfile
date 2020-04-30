FROM ruby:2.3
ARG SECRET_KEYBASE

RUN apt-get update -qq &&\
    apt-get install -y build-essential libpq-dev nodejs libssl1.0-dev imagemagick apt-transport-https

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update && apt-get install yarn

RUN export PATH="$PATH:/opt/yarn-[version]/bin"

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
