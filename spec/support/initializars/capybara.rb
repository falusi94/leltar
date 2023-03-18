# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'

Capybara.default_driver = :selenium
Capybara.server = :puma, { Silent: true }
