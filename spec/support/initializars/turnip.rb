# frozen_string_literal: true

require 'turnip/rspec'

Dir[Rails.root.join('spec/**/*_steps.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include RSpec::Rails::RequestExampleGroup, type: :feature
  config.include WebHelpers, type: :feature
end
