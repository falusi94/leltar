# frozen_string_literal: true

require 'turnip/rspec'

Dir[Rails.root.join('spec/**/*_steps.rb')].each { |f| require f }
