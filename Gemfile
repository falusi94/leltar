# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.7.4'

gem 'rails', '~> 7.0.1'

gem 'bootsnap', require: false
gem 'pg'
gem 'puma'

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
  gem 'annotate', github: 'dabit/annotate_models', ref: '4582f874790d44a26286a06e052950e15eefddeb'

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
