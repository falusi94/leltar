# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.0.6'

gem 'rails', '~> 7.1.3'

gem 'bootsnap', require: false
gem 'pg'
gem 'puma'

gem 'jsbundling-rails'
gem 'mini_racer', platforms: :ruby
gem 'sass-rails'
gem 'stimulus-rails'
gem 'uglifier', '>= 1.3.0'

gem 'bcrypt', '~> 3.1.7'

gem 'activerecord_where_assoc'
gem 'draper'
gem 'haml'
gem 'image_processing'
gem 'jb'
gem 'json', '>= 2.0.0'
gem 'jwt'
gem 'kaminari'
gem 'paper_trail'
gem 'pundit'
gem 'ransack'
gem 'redis'
gem 'translate_enum'
gem 'turbo-rails'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_bot_rails'
end

group :development do
  gem 'annotate'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'

  gem 'dotenv-rails'

  gem 'rails_stats', require: false

  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'pundit-matchers'
  gem 'rspec-rails'

  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  gem 'turnip'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
