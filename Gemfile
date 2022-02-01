# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.6.8'

gem 'rails', '~> 6.1.4.4'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'pg'
gem 'puma', '~> 3.12'

gem 'mini_racer', platforms: :ruby
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'

gem 'bcrypt', '~> 3.1.7'

gem 'activerecord_where_assoc'
gem 'draper'
gem 'haml'
gem 'image_processing'
gem 'json', '>= 2.0.0'
gem 'kaminari'
gem 'paper_trail'
gem 'pundit'
gem 'ransack'
gem 'translate_enum'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'annotate'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'

  gem 'dotenv-rails'
end

group :test do
  gem 'factory_bot_rails'
  gem 'pundit-matchers'
  gem 'rspec-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
